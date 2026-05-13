#!/usr/bin/env bash

source "$CONFIG_DIR/helpers/icon_map.sh"
source "$CONFIG_DIR/helpers/colors.sh"

# Single batch refresh for every Aerospace workspace tile in the bar.
#
# One aerospace call enumerates windows in all workspaces; one sketchybar invocation
# applies every update.
#
# FOCUSED_WORKSPACE arrives via the triggering event; fall back to querying it so
# the script still works when invoked manually or from a non-workspace event.
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

declare -A icons_by_ws seen
while IFS=$'\t' read -r ws app; do
    [ -z "$ws" ] || [ -z "$app" ] && continue
    key="$ws|$app"
    [ -n "${seen[$key]:-}" ] && continue
    seen[$key]=1
    __icon_map "$app"
    icons_by_ws[$ws]+="$icon_result"
done < <(aerospace list-windows --all --format '%{workspace}'$'\t''%{app-name}')

# Workspaces are statically defined in aerospace config and cached by
# sketchybarrc at startup; fall back to a live query if the cache is gone.
WORKSPACES_CACHE="${TMPDIR:-/tmp}/sketchybar.workspaces"
if [ -r "$WORKSPACES_CACHE" ]; then
    workspaces=$(<"$WORKSPACES_CACHE")
else
    workspaces=$(aerospace list-workspaces --all)
fi

args=()
for sid in $workspaces; do
    icons="${icons_by_ws[$sid]:-}"
    args+=(--set space."$sid")
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

sketchybar "${args[@]}"
