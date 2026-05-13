#!/usr/bin/env bash

# Single source of truth for bluetooth audio battery indicators.
#
# The swift helper at $CONFIG_DIR/helpers/bt_battery dumps every connected
# device's L/R/case/single percentages as JSON; we just pick the fields we want.

HEADPHONE_NAME="Tom's Headphones"
HELPER="$CONFIG_DIR/helpers/bt_battery"

JSON="$("$HELPER" 2>/dev/null)"
[ -z "$JSON" ] && JSON="[]"

# AirPods are whatever device first reports a non-zero L/R/case (those selectors
# only respond on Apple multi-battery devices). Headphones are matched by name.
read -r AP_L AP_R AP_C HP < <(jq -r --arg name "$HEADPHONE_NAME" '
    def airpods: map(select(.left > 0 or .right > 0 or .case > 0)) | first;
    def headphones: map(select(.name == $name)) | first;
    [
        (airpods.left // 0),
        (airpods.right // 0),
        (airpods.case // 0),
        (headphones.single // 0)
    ] | @tsv
' <<<"$JSON")

ARGS=()
apply() {
    local name=$1 value=$2
    if [ -z "$value" ] || [ "$value" = "0" ]; then
        ARGS+=(--set "$name" drawing=off)
    else
        ARGS+=(--set "$name" drawing=on "label=${value}%")
    fi
}

apply airpods.left "$AP_L"
apply airpods.right "$AP_R"
apply airpods.case "$AP_C"
apply headphones "$HP"

sketchybar "${ARGS[@]}"
