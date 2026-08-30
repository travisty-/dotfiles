"""Claude Code session dashboard, rendered with fzf.

One row per session, reloaded via --listen when the session registry
changes. Selecting a row jumps to that session's tmux pane, or to the
terminal window hosting it.
"""

import json
import os
import shutil
import socket
import subprocess
import sys
import threading
import time
from datetime import datetime

REFRESH_INTERVAL = 30  # Refresh at least this often

RED = '\033[38;2;226;108;108m'
GREEN = '\033[38;2;139;193;126m'
YELLOW = '\033[38;2;226;166;92m'
DIM = '\033[38;2;86;91;102m'
RESET = '\033[0m'

PRIORITIES = {'waiting': 0, 'idle': 1, 'busy': 2}
COLORS = {'waiting': RED, 'idle': GREEN, 'busy': YELLOW}
STATUS_WIDTH = 9  # Fits '● waiting', the widest status cell.

# Transcript entries that carry tool data rather than conversation.
SYNTHETIC_PREFIXES = (
    '<command-',
    '<local-command-',
    '<task-notification>',
)

CONFIG_DIR = os.environ.get('CLAUDE_CONFIG_DIR', '~/.claude')
SESSIONS_DIR = os.path.join(os.path.expanduser(CONFIG_DIR), 'sessions')

FZF_OPTIONS = [
    '--ansi',
    '--no-sort',
    '--layout=reverse-list',
    '--info=hidden',
    '--header-lines=1',
    '--highlight-line',
    '--delimiter=\t',
    '--with-nth=2',
    '--with-shell=sh -c',
]


def scan_sessions() -> list[tuple[str, int]]:
    """Return the name and last-modified time of each session file."""
    try:
        with os.scandir(SESSIONS_DIR) as files:
            return sorted((f.name, f.stat().st_mtime_ns) for f in files)
    except OSError:
        return []


def list_sessions() -> list[dict] | None:
    """List active sessions, or None when the query fails."""
    try:
        result = subprocess.run(
            ['claude', 'agents', '--json'],
            capture_output=True,
            check=True,
            text=True,
            stdin=subprocess.DEVNULL,
            timeout=10,
        )
        sessions = json.loads(result.stdout)
    except (OSError, ValueError, subprocess.SubprocessError):
        return None
    if not isinstance(sessions, list):
        return None
    for session in sessions:
        session['statusUpdatedAt'] = read_status_updated_at(session)
    return sessions


def read_status_updated_at(session: dict) -> int:
    """Read a session's last status transition from its registry file."""
    registry = read_registry(session.get('pid'))
    stamp = registry.get('statusUpdatedAt', session.get('startedAt'))
    try:
        return int(stamp)
    except (TypeError, ValueError):
        return 0


def humanize_age(timestamp_ms: int) -> str:
    """Format the time since an epoch-ms timestamp compactly."""
    value = max(0, int(time.time() - timestamp_ms / 1000))
    for limit, unit in ((60, 's'), (60, 'm'), (24, 'h')):
        if value < limit:
            return f'{value}{unit}'
        value //= limit
    return f'{value}d'


def list_width() -> int:
    """Width of fzf's list area: half the window, minus the gutter."""
    try:
        columns = int(os.environ['FZF_COLUMNS'])
    except (KeyError, ValueError):
        columns = shutil.get_terminal_size().columns
    return columns // 2 - 3


def render_rows(sessions: list[dict]) -> str:
    """Render the header and one aligned, colored row per session."""
    home = os.path.expanduser('~')
    cells = []
    for session in sessions:
        cwd = session.get('cwd', '')
        if cwd == home or cwd.startswith(home + '/'):
            cwd = '~' + cwd.removeprefix(home)
        background = session.get('kind') != 'interactive'
        name = session.get('name', '')
        age = humanize_age(session['statusUpdatedAt'])
        reason = session.get('waitingFor')
        cells.append(
            (
                str(session.get('pid', 0)),
                session.get('status', ''),
                f'↳ {name}' if background else name,
                cwd,
                f'{age}  · {reason}' if reason else age,
                background,
            )
        )
    pid_width = max([len(cell[0]) for cell in cells] + [3])
    name_width = max([len(cell[2]) for cell in cells] + [4])
    cwd_width = max([len(cell[3]) for cell in cells] + [4])
    age_width = max([len(cell[4]) for cell in cells] + [3])
    used = (
        STATUS_WIDTH + pid_width + name_width + cwd_width + age_width + 4 * 2
    )
    extra = list_width() - used
    if extra > 0:
        name_width += extra // 2
        cwd_width += extra - extra // 2
    lines = [
        f'\t{DIM}{"STATUS":<{STATUS_WIDTH}}  {"PID":>{pid_width}}  '
        f'{"NAME":<{name_width}}  {"PATH":<{cwd_width}}  AGE{RESET}'
    ]
    for pid, status, name, cwd, age, background in cells:
        color = COLORS.get(status, DIM)
        lines.append(
            f'{pid}\t{color}{"● " + status:<{STATUS_WIDTH}}{RESET}  '
            f'{DIM}{pid:>{pid_width}}{RESET}  '
            f'{DIM if background else ""}{name:<{name_width}}{RESET}  '
            f'{DIM}{cwd:<{cwd_width}}  {age}{RESET}'
        )
    return '\n'.join(lines) + '\n'


def rank_session(session: dict) -> tuple[str, int, int]:
    """Sort key: project, then status priority, then longest in state."""
    return (
        session.get('cwd', '').lower(),
        PRIORITIES.get(session.get('status'), 3),
        session['statusUpdatedAt'],
    )


def order_sessions(sessions: list[dict]) -> list[dict]:
    """Order sessions by rank, background agents behind their parent."""
    interactive = {
        session.get('pid')
        for session in sessions
        if session.get('kind') == 'interactive'
    }
    if len(interactive) < len(sessions):
        try:
            parents = find_parents()
        except (OSError, subprocess.SubprocessError, ValueError):
            parents = {}
    else:
        parents = {}
    roots: list[dict] = []
    children: dict[int, list[dict]] = {}
    for session in sessions:
        owner = None
        if session.get('kind') != 'interactive':
            for pid in trace_ancestors(session.get('pid', 0), parents)[1:]:
                if pid in interactive:
                    owner = pid
                    break
        if owner is None:
            roots.append(session)
        else:
            children.setdefault(owner, []).append(session)
    ordered = []
    for root in sorted(roots, key=rank_session):
        ordered.append(root)
        subagents = children.get(root.get('pid'), [])
        ordered.extend(sorted(subagents, key=rank_session))
    return ordered


def write_cache(cache_path: str, sessions: list[dict]) -> None:
    """Atomically replace the session cache."""
    tmp_path = f'{cache_path}.{os.getpid()}.tmp'
    with open(tmp_path, 'w') as cache_file:
        json.dump(sessions, cache_file)
    os.replace(tmp_path, cache_path)


def load_sessions(cache_path: str) -> list[dict]:
    """Load sessions from the cache, which the watcher keeps fresh."""
    try:
        with open(cache_path) as cache_file:
            return json.load(cache_file)
    except (OSError, ValueError):
        return []


def build_rows(cache_path: str) -> str:
    """Build the full dashboard input for fzf."""
    return render_rows(order_sessions(load_sessions(cache_path)))


def pick_port() -> int:
    """Reserve an ephemeral localhost port for fzf's listen endpoint."""
    with socket.socket() as probe:
        probe.bind(('127.0.0.1', 0))
        return probe.getsockname()[1]


def request_reload(port: int, command: str) -> None:
    """Ask the running fzf to reload its rows."""
    import urllib.request  # --rows and --preview skip the import.

    request = urllib.request.Request(
        f'http://127.0.0.1:{port}',
        data=f'reload({command})'.encode(),
    )
    try:
        urllib.request.urlopen(request, timeout=2)
    except OSError:
        pass


def watch_sessions(port: int, cache_path: str, reload_command: str) -> None:
    """Refetch when the registry changes or the refresh floor lapses."""
    last_modified_at: list[tuple[str, int]] | None = None
    refreshed_at = 0.0
    while True:
        modified_at = scan_sessions()
        expired = time.monotonic() - refreshed_at >= REFRESH_INTERVAL
        needs_refresh = modified_at != last_modified_at or expired
        if needs_refresh:
            last_modified_at = modified_at
            refreshed_at = time.monotonic()
            sessions = list_sessions()
            if sessions is not None:
                write_cache(cache_path, sessions)
            request_reload(port, reload_command)
        time.sleep(1)


def find_parents() -> dict[int, int]:
    """Map every process to its parent, from one ps snapshot."""
    snapshot = subprocess.run(
        ['ps', '-Ao', 'pid=,ppid='],
        capture_output=True,
        check=True,
        text=True,
    )
    parents = {}
    for line in snapshot.stdout.splitlines():
        pid, ppid = line.split()
        parents[int(pid)] = int(ppid)
    return parents


def trace_ancestors(pid: int, parents: dict[int, int]) -> list[int]:
    """Return a process and its ancestors, nearest first."""
    ancestors = []
    while pid > 1 and pid not in ancestors:
        ancestors.append(pid)
        pid = parents.get(pid, 0)
    return ancestors


def call_tmux(*arguments: str) -> str:
    """Run one tmux command and return its output."""
    result = subprocess.run(
        ['tmux', *arguments],
        capture_output=True,
        check=True,
        text=True,
    )
    return result.stdout


def notify(message: str) -> None:
    """Show a message on the tmux status line, which outlives the popup."""
    try:
        call_tmux('display-message', message)
    except (OSError, subprocess.SubprocessError):
        print(message, flush=True)


def find_pane(ancestors: list[int]) -> tuple[str, str, str] | None:
    """Find the tmux pane hosting any of the given processes."""
    panes = {}
    for line in call_tmux(
        'list-panes',
        '-aF',
        '#{pane_pid}\t#{pane_id}\t#{window_id}\t#{session_id}',
    ).splitlines():
        pane_pid, pane_id, window_id, session_id = line.split('\t')
        panes[int(pane_pid)] = (pane_id, window_id, session_id)
    for pid in ancestors:
        if pid in panes:
            return panes[pid]
    return None


def focus_terminal(ancestors: list[int]) -> bool:
    """Focus the niri window that hosts any of the given processes."""
    try:
        listing = subprocess.run(
            ['niri', 'msg', '--json', 'windows'],
            capture_output=True,
            check=True,
            text=True,
        )
        windows = {w['pid']: w['id'] for w in json.loads(listing.stdout)}
    except (OSError, ValueError, KeyError, subprocess.SubprocessError):
        return False
    for pid in ancestors:
        if pid in windows:
            subprocess.run(
                [
                    'niri',
                    'msg',
                    'action',
                    'focus-window',
                    '--id',
                    str(windows[pid]),
                ],
                check=False,
            )
            return True
    return False


def read_registry(pid: int) -> dict:
    """Read a session's registry file."""
    try:
        with open(os.path.join(SESSIONS_DIR, f'{pid}.json')) as state_file:
            return json.load(state_file)
    except (OSError, ValueError):
        return {}


def find_transcript(pid: int) -> str | None:
    """Locate a session's transcript file."""
    registry = read_registry(pid)
    session_id = registry.get('sessionId')
    cwd = registry.get('cwd')
    if not session_id or not cwd:
        return None
    slug = cwd.replace('/', '-').replace('.', '-')
    path = os.path.join(
        os.path.expanduser(CONFIG_DIR),
        'projects',
        slug,
        f'{session_id}.jsonl',
    )
    return path if os.path.exists(path) else None


def render_transcript(path: str) -> str:
    """Render the last few conversation messages of a transcript."""
    try:
        with open(path, 'rb') as transcript:
            transcript.seek(0, os.SEEK_END)
            size = transcript.tell()
            transcript.seek(max(0, size - 262144))
            tail = transcript.read().decode('utf-8', 'replace')
    except OSError:
        return ''
    lines = tail.split('\n')
    messages = []
    for line in lines:
        try:
            entry = json.loads(line)
        except ValueError:
            continue
        role = entry.get('type')
        if role not in ('user', 'assistant') or entry.get('isMeta'):
            continue
        content = entry.get('message', {}).get('content')
        if isinstance(content, str):
            text = content
        elif isinstance(content, list):
            text = '\n'.join(
                part.get('text', '')
                for part in content
                if isinstance(part, dict) and part.get('type') == 'text'
            )
        else:
            continue
        text = text.strip()
        if text and not text.startswith(SYNTHETIC_PREFIXES):
            messages.append((role, read_stamp(entry), text))
    sections = [
        f'{DIM}── {role}{stamp} ──{RESET}\n{text}'
        for role, stamp, text in messages[-5:]
    ]
    return '\n\n'.join(sections)


def read_stamp(entry: dict) -> str:
    """Format a transcript entry's timestamp as local wall-clock time."""
    try:
        moment = datetime.fromisoformat(entry['timestamp'])
    except (KeyError, TypeError, ValueError):
        return ''
    return moment.astimezone().strftime(' · %H:%M:%S')


def preview_session(pid: int) -> None:
    """Show the tail of the session's transcript."""
    transcript = find_transcript(pid)
    rendered = render_transcript(transcript) if transcript else ''
    print(rendered or 'no preview available', flush=True)


def jump_to_session(pid: int) -> None:
    """Jump to a session's pane, or to the terminal that hosts it."""
    parents = find_parents()
    ancestors = trace_ancestors(pid, parents)
    try:
        pane = find_pane(ancestors)
    except (OSError, subprocess.SubprocessError):
        pane = None
    if pane is None:
        if not focus_terminal(ancestors):
            notify('no pane or window found for the session')
        return
    pane_id, window_id, session_id = pane
    call_tmux('select-window', '-t', window_id)
    call_tmux('select-pane', '-t', pane_id)
    current = call_tmux('display-message', '-p', '#{session_id}').strip()
    if session_id == current:
        return
    for line in call_tmux(
        'list-clients', '-F', '#{client_pid}\t#{session_id}'
    ).splitlines():
        client_pid, client_session = line.split('\t')
        if client_session == session_id:
            if focus_terminal(trace_ancestors(int(client_pid), parents)):
                return
            break
    call_tmux('switch-client', '-t', session_id)


def main() -> None:
    """Run fzf over live session rows and jump to the selection."""
    runtime_dir = os.environ.get('XDG_RUNTIME_DIR', '/tmp')
    cache_path = os.path.join(
        runtime_dir, f'tmux-claude-dashboard.{os.getpid()}.cache'
    )
    self_path = sys.argv[0]
    reload_command = f'{self_path} --rows {cache_path}'
    port = pick_port()
    try:
        watcher = threading.Thread(
            target=watch_sessions,
            args=(port, cache_path, reload_command),
            daemon=True,
        )
        watcher.start()
        picker = subprocess.run(
            [
                'fzf',
                *FZF_OPTIONS,
                f'--listen=127.0.0.1:{port}',
                f'--bind=start:reload({reload_command})',
                f'--preview={self_path} --preview {{1}}',
                '--preview-window=right,50%,wrap,follow',
            ],
            input='',
            stdout=subprocess.PIPE,
            text=True,
            check=False,
        )
    finally:
        try:
            os.remove(cache_path)
        except OSError:
            pass
    selection = picker.stdout.strip()
    if picker.returncode == 0 and selection:
        try:
            jump_to_session(int(selection.split('\t', 1)[0]))
        except (OSError, ValueError, subprocess.SubprocessError):
            notify('jump failed')


if __name__ == '__main__':
    if sys.argv[1:2] == ['--preview']:
        preview_session(int(sys.argv[2]))
    elif sys.argv[1:2] == ['--rows']:
        print(build_rows(sys.argv[2]), end='')
    else:
        main()
