#!/usr/bin/env bash

source "$CONFIG_DIR/helpers/icon_map.sh"
source "$CONFIG_DIR/helpers/colors.sh"

SID=$1

# Collect unique app names for windows in this workspace.
apps=$(aerospace list-windows --workspace "$SID" --format '%{app-name}' | sort -u)

icons=""
while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    icons+="$icon_result"
done <<<"$apps"

args=()

# Mauve at ~53% alpha for the focused workspace, Surface0 at half alpha for
# occupied-but-unfocused: barely there so the mauve accent does the heavy lifting.
if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
    args+=(drawing=on background.drawing=on background.color="0x88${MAUVE}")
elif [ -n "$apps" ]; then
    args+=(drawing=on background.drawing=on background.color="0x80${SURFACE0}")
else
    args+=(drawing=off)
fi

if [ -n "$icons" ]; then
    args+=(label="$icons" label.drawing=on)
else
    args+=(label.drawing=off)
fi

sketchybar --set "$NAME" "${args[@]}"
