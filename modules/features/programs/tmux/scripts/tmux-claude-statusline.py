"""Claude Code session counts by status."""

import json
import os
import subprocess
import time

REFRESH_INTERVAL = 60  # Refresh at least this often

DIM = '#[fg=#565b66]'
IDLE = '#[fg=#8bc17e]'
BUSY = '#[fg=#e2a65c]'
WAITING = '#[fg=#e26c6c]'
RESET = '#[default]'

SEPARATOR = f'{DIM}  ·  {RESET}'
STATUSES: tuple[str, ...] = ('idle', 'busy', 'waiting')

CONFIG_DIR = os.environ.get('CLAUDE_CONFIG_DIR', '~/.claude')
SESSIONS_DIR = os.path.join(os.path.expanduser(CONFIG_DIR), 'sessions')


def scan_sessions() -> list[tuple[str, int]]:
    """Return the name and last-modified time of each session file."""
    try:
        with os.scandir(SESSIONS_DIR) as files:
            return sorted((f.name, f.stat().st_mtime_ns) for f in files)
    except OSError:
        return []


def count_sessions() -> dict[str, int]:
    """Count the number of active sessions in each status. -1 on failure."""
    counts = dict.fromkeys(STATUSES, 0)
    try:
        result = subprocess.run(
            ['claude', 'agents', '--json'],
            capture_output=True,
            check=True,
            text=True,
            stdin=subprocess.DEVNULL,
            timeout=5,
        )
        sessions = json.loads(result.stdout)
    except (OSError, ValueError, subprocess.SubprocessError):
        return dict.fromkeys(STATUSES, -1)
    for session in sessions:
        status = session.get('status')
        if status in counts:
            counts[status] += 1
    return counts


def render_slot(color: str, count: int) -> str:
    """Render one slot of a frame, dimmed when its count is zero."""
    return f'{color if count else DIM}● {count}{RESET}'


def render_frame(counts: dict[str, int]) -> str:
    """Render a complete frame, or nothing when all counts are zero."""
    if min(counts.values()) < 0:
        return f'{WAITING}● !{RESET} '
    if not any(counts.values()):
        return ''
    slots = [
        render_slot(IDLE, counts['idle']),
        render_slot(BUSY, counts['busy']),
        render_slot(WAITING, counts['waiting']),
    ]
    return f'{SEPARATOR.join(slots)} '


def main() -> None:
    """Watch sessions and render a new frame when there is a change."""
    counts = dict.fromkeys(STATUSES, 0)
    last_modified_at: list[tuple[str, int]] | None = None
    last_frame: str | None = None
    refreshed_at = 0.0

    while True:
        modified_at = scan_sessions()
        expired = time.monotonic() - refreshed_at >= REFRESH_INTERVAL
        needs_refresh = modified_at != last_modified_at or expired
        if needs_refresh:
            last_modified_at = modified_at
            refreshed_at = time.monotonic()
            counts = count_sessions()
        frame = render_frame(counts)
        if frame != last_frame:
            print(frame, flush=True)
            last_frame = frame
        time.sleep(1)


if __name__ == '__main__':
    main()
