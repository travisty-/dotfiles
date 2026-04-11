#!/usr/bin/env python3

# https://nyosegawa.com/posts/claude-code-statusline-rate-limits
"""Pattern 2: Sparkline gauge - Vertical block characters"""

import json
import sys

data = json.load(sys.stdin)

SPARKS = ' ▁▂▃▄▅▆▇█'
DIM = '\033[2m'
RESET = '\033[0m'

def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g, 0)};60m'

def spark_gauge(pct, width=8):
    pct = min(max(pct, 0), 100)
    level = pct / 100
    gauge = ''
    for i in range(width):
        seg_start = i / width
        seg_end = (i + 1) / width
        if level >= seg_end:
            gauge += SPARKS[8]
        elif level <= seg_start:
            gauge += SPARKS[0]
        else:
            frac = (level - seg_start) / (seg_end - seg_start)
            gauge += SPARKS[int(frac * 8)]
    return gauge

def fmt(label, pct):
    p = round(pct)
    return f'{DIM}{label}{RESET} {gradient(pct)}{spark_gauge(pct)}{RESET} {p}%'

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

print(f' {DIM}│{RESET} '.join(parts), end='')
