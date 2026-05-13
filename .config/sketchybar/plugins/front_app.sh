#!/usr/bin/env bash

# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
# $INFO carries the newly focused app name on front_app_switched.

if [ "$SENDER" = "front_app_switched" ]; then
    source "$CONFIG_DIR/helpers/icon_map.sh"
    __icon_map "$INFO"
    sketchybar --set "$NAME" icon="$icon_result" label="$INFO"
fi
