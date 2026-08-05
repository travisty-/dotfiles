# https://nyosegawa.com/posts/claude-code-statusline-rate-limits
"""Pattern 4: Fine-grained progress bar with true color gradient"""

import json
import sys

data = json.load(sys.stdin)

BLOCKS = ' ▏▎▍▌▋▊▉█'
DIM = '\033[2m'
RESET = '\033[0m'


def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g, 0)};60m'


def bar(pct, width=10):
    pct = min(max(pct, 0), 100)
    filled = pct * width / 100
    full = int(filled)
    frac = int((filled - full) * 8)
    b = '█' * full
    if full < width:
        b += BLOCKS[frac]
        b += '░' * (width - full - 1)
    return b


def fmt(label, pct):
    p = round(pct)
    return f'{label} {gradient(pct)}{bar(pct)} {p}%{RESET}'


model = data.get('model', {}).get('display_name', 'Claude')
parts = [model]

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

print(f'{DIM}│{RESET}'.join(f' {p} ' for p in parts), end='')
