#!/usr/bin/env bash

if [ -n "$MODE" ] && [ "$MODE" != "main" ]; then
    sketchybar --set "$NAME" drawing=on label="$MODE"
else
    sketchybar --set "$NAME" drawing=off
fi
