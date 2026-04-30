"""
Directional movement for Hyprland. Selected via the `mode` argument: `focus`
navigates focus across windows, `window` moves the focused window's position.

Grouped windows rotate within the group (window mode) or cycle the active tab
(focus mode) when the direction allows, or exit the group boundary otherwise.

Ungrouped windows merge into adjacent groups (window mode) or move focus to the
next window (focus mode), falling back to a normal move if no group is adjacent.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from collections.abc import Iterable
from dataclasses import dataclass
from enum import StrEnum
from typing import Any, Literal, NamedTuple, NotRequired, Self, TypedDict


DispatchCommand = Literal[
    "movefocus",
    "movewindow",
    "movegroupwindow",
    "moveintogroup",
    "moveoutofgroup",
    "changegroupactive",
]


class WindowPayload(TypedDict):
    address: str
    at: list[int]
    size: list[int]
    grouped: NotRequired[list[str]]
    floating: NotRequired[bool]
    fullscreen: NotRequired[int]


class Mode(StrEnum):
    FOCUS = "focus"
    WINDOW = "window"


class Direction(StrEnum):
    UP = "u"
    DOWN = "d"
    LEFT = "l"
    RIGHT = "r"

    @property
    def axis(self) -> int:
        """Point index for the parallel axis: 0 for x, 1 for y."""
        return 0 if self in (Direction.LEFT, Direction.RIGHT) else 1

    @property
    def sign(self) -> int:
        """+1 if motion increases the parallel coordinate, -1 otherwise."""
        return -1 if self in (Direction.UP, Direction.LEFT) else 1

    def counter(self, drift: int) -> Direction:
        """Counters perpendicular drift by moving in the opposite direction."""
        if self.axis == 1:
            return Direction.LEFT if drift > 0 else Direction.RIGHT
        return Direction.UP if drift > 0 else Direction.DOWN


class Point(NamedTuple):
    x: int
    y: int

    def __sub__(self, other: Point) -> Point:
        """Component-wise subtraction, for calculating deltas."""
        return Point(self.x - other.x, self.y - other.y)


@dataclass(frozen=True, slots=True)
class Window:
    address: str
    group: tuple[str, ...]
    center: Point
    floating: bool
    fullscreen: bool

    @classmethod
    def from_json(cls, payload: WindowPayload) -> Self:
        """Builds a window from Hyprland's `activewindow` JSON payload."""
        left, top = payload["at"]
        width, height = payload["size"]
        return cls(
            address=payload["address"],
            group=tuple(payload.get("grouped") or ()),
            center=Point(left + width // 2, top + height // 2),
            floating=payload.get("floating", False),
            fullscreen=payload.get("fullscreen", 0) != 0,
        )

    @property
    def is_grouped(self) -> bool:
        """True when the window is in a group with at least two members."""
        return len(self.group) > 1

    @property
    def position(self) -> int:
        """The index of the window within its group (zero-based)."""
        return self.group.index(self.address)


def query(name: str) -> Any:
    """Return the deserialized JSON output of `hyprctl -j <name>`."""
    result = subprocess.run(
        ["hyprctl", "-j", name],
        capture_output=True,
        check=True,
        text=True,
    )
    return json.loads(result.stdout)


def dispatch(command: DispatchCommand, *arguments: str) -> None:
    """Run `hyprctl dispatch <command> <arguments>`."""
    subprocess.run(["hyprctl", "dispatch", command, *arguments], check=True, stdout=subprocess.DEVNULL)


def capture(command: DispatchCommand, *arguments: str) -> Window:
    """Run `dispatch` and capture the active window afterward."""
    return dispatch(command, *arguments) or active_window()


def batch(calls: Iterable[tuple[DispatchCommand, *tuple[str, ...]]]) -> None:
    """Dispatch multiple calls in a single `hyprctl --batch` invocation."""
    if commands := ";".join("dispatch " + " ".join(call) for call in calls):
        subprocess.run(["hyprctl", "--batch", commands], check=True, stdout=subprocess.DEVNULL)


def active_window() -> Window:
    """Return the currently active (focused) window."""
    return Window.from_json(query("activewindow"))


def enforce_direction(before: Window, after: Window, direction: Direction) -> None:
    """Enforce that the active window always moves in the requested direction.

    Hyprland's `moveoutofgroup` placement is heuristic (tile-shape driven,
    not direction-driven), so we need to chain a corrective `movewindow` if
    the result didn't move along the requested axis and correct any drift.
    """
    if not followed_direction(before, after, direction):
        after = capture("movewindow", direction)
    correct_drift(before, after, direction)


def followed_direction(before: Window, after: Window, direction: Direction) -> bool:
    """True if the window's center moved predominantly along the `direction`s axis.
    Ignores small perpendicular drift introduced by things like padding around tiles.
    """
    delta = after.center - before.center
    motion = delta[direction.axis]
    drift = delta[1 - direction.axis]
    return motion * direction.sign > 0 and abs(motion) > abs(drift)


def correct_drift(before: Window, after: Window, direction: Direction) -> None:
    """Counter perpendicular drift if it exceeded the total motion."""
    delta = after.center - before.center
    motion = delta[direction.axis]
    drift = delta[1 - direction.axis]
    if abs(drift) > abs(motion):
        dispatch("movewindow", direction.counter(drift))


def cycle(window: Window, direction: Direction, command: DispatchCommand) -> bool:
    """Cycle the active position horizontally within a group. Returns False when
    crossing the group boundary or when the specified direction was UP or DOWN."""
    match direction, window.position:
        case Direction.LEFT, position if position > 0:
            dispatch(command, "b")
            return True
        case Direction.RIGHT, position if position < len(window.group) - 1:
            dispatch(command, "f")
            return True
    return False


def shift_grouped(window: Window, direction: Direction) -> None:
    """Shift the active window within a group, or eject it through the boundary."""
    if not cycle(window, direction, "movegroupwindow"):
        ejected = capture("moveoutofgroup", direction)
        enforce_direction(window, ejected, direction)


def place_adjacent(window: Window, direction: Direction, command: DispatchCommand) -> None:
    """Place a window into a group adjacent to the nearest edge.

    1. RIGHT and DOWN will be placed at the head (leftmost).
    2. LEFT and UP will be placed at the tail (rightmost).
    """
    reverse = direction in (Direction.UP, Direction.LEFT)
    target = (len(window.group) - 1) if reverse else 0
    arg = "b" if window.position > target else "f"
    batch([(command, arg)] * abs(window.position - target))


def merge_into(direction: Direction) -> None:
    """Merge a non-grouped window into an adjacent group, or fall back to a normal move."""
    merged = capture("moveintogroup", direction)
    if merged.is_grouped:
        place_adjacent(merged, direction, "movegroupwindow")
        return
    moved = capture("movewindow", direction)
    correct_drift(merged, moved, direction)


def move_focus(direction: Direction) -> None:
    """Move the active focus directionally with group-aware navigation."""
    window = active_window()
    if window.fullscreen or window.floating:
        dispatch("movefocus", direction)
        return
    if window.is_grouped and cycle(window, direction, "changegroupactive"):
        return
    focused = capture("movefocus", direction)
    if focused.is_grouped:
        place_adjacent(focused, direction, "changegroupactive")


def move_window(direction: Direction) -> None:
    """Move the active window directionally with group-aware navigation."""
    window = active_window()
    if window.fullscreen or window.floating:
        return
    if window.is_grouped:
        shift_grouped(window, direction)
    else:
        merge_into(direction)


def main() -> None:
    if not os.environ.get("HYPRLAND_INSTANCE_SIGNATURE"):
        sys.exit("Not running Hyprland? (HYPRLAND_INSTANCE_SIGNATURE not set)")

    parser = argparse.ArgumentParser(description="Directional movement for Hyprland.")
    parser.add_argument("mode", type=Mode, choices=list(Mode))
    parser.add_argument("direction", type=Direction, choices=list(Direction))
    args = parser.parse_args()

    try:
        match args.mode:
            case Mode.FOCUS: move_focus(args.direction)
            case Mode.WINDOW: move_window(args.direction)
    except (OSError, subprocess.CalledProcessError, json.JSONDecodeError, KeyError, TypeError, ValueError) as e:
        sys.exit(f"hyprctl error: {e}")


if __name__ == "__main__":
    main()
