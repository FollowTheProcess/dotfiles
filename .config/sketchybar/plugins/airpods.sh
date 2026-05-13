#!/usr/bin/env bash

# Originally adapted from
# https://github.com/nicolas-martin/awesome-sketchybar/blob/master/plugins/Airpods-Battery.md
# but tweaked a bit more modern macOS: system_profiler's JSON output exposes
# per-ear and case battery levels directly, so I just read directly from that

INFO="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null |
    jq -r '
        (.SPBluetoothDataType[0].device_connected // [])
        | map(to_entries[])
        | map(select(.value.device_minorType == "Headphones"))
        | first
        | if . == null then "DISCONNECTED"
          else "\(.value.device_batteryLevelLeft // "-")|\(.value.device_batteryLevelCase // "-")|\(.value.device_batteryLevelRight // "-")"
          end
    ')"

ARGS=()

# An item is "reporting" when it has a non-empty, non-zero percentage.
# A 0%/"-" reading means that part isn't connected (ear in case, case away).
apply_item() {
    local name=$1 value=$2
    if [ -z "$value" ] || [ "$value" = "-" ] || [ "$value" = "0%" ]; then
        ARGS+=(--set "$name" drawing=off)
    else
        ARGS+=(--set "$name" drawing=on "label=$value")
    fi
}

if [ "$INFO" = "DISCONNECTED" ] || [ -z "$INFO" ]; then
    apply_item airpods.left ""
    apply_item airpods.case ""
    apply_item airpods.right ""
else
    IFS='|' read -r LEFT CASE RIGHT <<<"$INFO"
    apply_item airpods.left "$LEFT"
    apply_item airpods.case "$CASE"
    apply_item airpods.right "$RIGHT"
fi

sketchybar "${ARGS[@]}"
