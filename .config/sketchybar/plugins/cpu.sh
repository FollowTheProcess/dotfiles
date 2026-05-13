#!/usr/bin/env bash

# ps's %cpu is a decaying average per process (kernel-maintained, no sampling
# cost). Summing and dividing by core count yields a 0-100% reading.
CORES=$(sysctl -n hw.logicalcpu)
PERCENTAGE=$(ps -A -o %cpu | awk -v cores="$CORES" 'NR>1 {sum+=$1} END {printf "%.0f", sum/cores}')

sketchybar --set "$NAME" label="${PERCENTAGE}%"
