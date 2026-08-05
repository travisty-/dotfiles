# https://nyosegawa.com/posts/claude-code-statusline-rate-limits
"""Pattern 1: Minimal dots - Colored circles with numbers only"""

import json
import sys

data = json.load(sys.stdin)

DIM = '\033[2m'
BOLD = '\033[1m'
RESET = '\033[0m'


def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g, 0)};60m'


def dot(pct):
    p = round(pct)
    return f'{gradient(pct)}●{RESET} {BOLD}{p}%{RESET}'


model = data.get('model', {}).get('display_name', 'Claude')
parts = [f'{BOLD}{model}{RESET}']

ctx = data.get('context_window', {}).get('used_percentage')
if ctx is not None:
    parts.append(f'ctx {dot(ctx)}')

five = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
if five is not None:
    parts.append(f'5h {dot(five)}')

week = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
if week is not None:
    parts.append(f'7d {dot(week)}')

cost = data.get('cost', {}).get('total_cost_usd')
if cost is not None:
    parts.append(f'{DIM}${cost:.2f}{RESET}')

print(f'  {DIM}·{RESET}  '.join(parts), end='')
