#!/usr/bin/env bash

PMSET="$(pmset -g batt)"

# Bash regex
if [[ $PMSET =~ ([0-9]+)% ]]; then
    PERCENTAGE="${BASH_REMATCH[1]}"
else
    exit 0
fi

case "${PERCENTAGE}" in
9[0-9] | 100)
    ICON="􀛨"
    ;;
[6-8][0-9])
    ICON="􀺸"
    ;;
[3-5][0-9])
    ICON="􀺶"
    ;;
[1-2][0-9])
    ICON="􀛩"
    ;;
*) ICON="􀛪" ;;
esac

if [[ $PMSET == *"AC Power"* ]]; then
    ICON="􀢋"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
