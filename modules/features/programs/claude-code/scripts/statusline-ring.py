# https://nyosegawa.com/posts/claude-code-statusline-rate-limits
"""Pattern 3: Ring meter - Pie-like circle segments"""

import json
import sys

data = json.load(sys.stdin)

DIM = '\033[2m'
BOLD = '\033[1m'
RESET = '\033[0m'

RINGS = ['○', '◔', '◑', '◕', '●']


def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g, 0)};60m'


def ring(pct):
    idx = min(int(pct / 25), 4)
    return RINGS[idx]


def fmt(label, pct):
    p = round(pct)
    return f'{DIM}{label}{RESET} {gradient(pct)}{ring(pct)} {p}%{RESET}'


model = data.get('model', {}).get('display_name', 'Claude')
parts = [f'{BOLD}{model}{RESET}']

ctx = data.get('context_window', {}).get('used_percentage')
if ctx is not None:
    parts.append(fmt('ctx', ctx))

five = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
if five is not None:
    parts.append(fmt('5h', five))

week = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
if week is not None:
    parts.append(fmt('7d', week))

cost = data.get('cost', {}).get('total_cost_usd')
if cost is not None:
    parts.append(f'{DIM}${cost:.2f}{RESET}')

print('  '.join(parts), end='')
