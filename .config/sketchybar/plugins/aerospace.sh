#!/usr/bin/env bash

source "$CONFIG_DIR/helpers/icon_map.sh"
source "$CONFIG_DIR/helpers/colors.sh"

# Single batch refresh for every Aerospace workspace tile in the bar.
#
# Tiles are added/removed dynamically to mirror aerospace's live workspace
# list (no static pre-registration in sketchybarrc). One aerospace call
# enumerates windows across all workspaces; one sketchybar invocation applies
# every change — add, remove, reorder, and per-tile state.
#
# FOCUSED_WORKSPACE arrives via the triggering event; fall back to querying
# it so the script still works when invoked manually.
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

# Workspace -> concatenated app icons string.
declare -A icons_by_ws seen
while IFS=$'\t' read -r ws app; do
    [ -z "$ws" ] || [ -z "$app" ] && continue
    key="$ws|$app"
    [ -n "${seen[$key]:-}" ] && continue
    seen[$key]=1
    __icon_map "$app"
    icons_by_ws[$ws]+="$icon_result"
done < <(aerospace list-windows --all --format '%{workspace}'$'\t''%{app-name}')

# Reconcile bar tiles with live aerospace workspaces. Without persistent
# workspaces, aerospace creates/destroys workspaces on demand, so the bar
# needs to add/remove its space.* items to match.
current=$(aerospace list-workspaces --all)
existing=$(sketchybar --query bar 2>/dev/null |
    jq -r '.items[] | select(startswith("space."))' |
    sed 's/^space\.//')

to_add=$(comm -23 <(echo "$current" | sort) <(echo "$existing" | sort))
to_remove=$(comm -13 <(echo "$current" | sort) <(echo "$existing" | sort))

args=()

for sid in $to_add; do
    args+=(
        --add item "space.$sid" left
        --set "space.$sid"
        icon="$sid"
        icon.padding_left=10
        icon.padding_right=6
        label.font="sketchybar-app-font:Regular:14.0"
        label.padding_left=0
        label.padding_right=10
        label.drawing=off
        background.color="0x80${SURFACE0}"
        background.corner_radius=6
        background.height=26
        background.drawing=off
        click_script="aerospace workspace $sid"
    )
done

for sid in $to_remove; do
    args+=(--remove "space.$sid")
done

# Force tiles to the leftmost edge of the bar, in numeric order. `--add ...
# left` appends to the right of any existing left-anchored items, which
# would land tiles after the network/mode/etc items. Each `--move` puts the
# tile immediately before `spaces_controller` (the hidden anchor item
# registered first in sketchybarrc); iterating in sorted order yields a
# contiguous space.1, space.2, ... run anchored to the left edge.
for sid in $(echo "$current" | sort -n); do
    args+=(--move "space.$sid" before spaces_controller)
done

# Per-tile state for every live workspace.
for sid in $current; do
    icons="${icons_by_ws[$sid]:-}"
    args+=(--set "space.$sid")
    if [ "$sid" = "$FOCUSED" ]; then
        args+=(drawing=on background.drawing=on background.color="0x88${MAUVE}")
    elif [ -n "$icons" ]; then
        args+=(drawing=on background.drawing=on background.color="0x80${SURFACE0}")
    else
        args+=(drawing=off)
    fi
    if [ -n "$icons" ]; then
        args+=(label="$icons" label.drawing=on)
    else
        args+=(label.drawing=off)
    fi
done

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
