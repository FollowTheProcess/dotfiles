#!/usr/bin/env bash

SID=$1

if [ "$SID" = "$FOCUSED_WORKSPACE" ] || [ -n "$(aerospace list-windows --workspace "$SID")" ]; then
    sketchybar --set "$NAME" drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi
