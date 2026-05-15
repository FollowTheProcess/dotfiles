#!/usr/bin/env bash

# State + throughput for the active network interface. Owned by the visible
# `network` item so one poll updates state and both throughput items in a
# single batched sketchybar call - no separate hidden controller.

source "$CONFIG_DIR/helpers/colors.sh"

CACHE="${TMPDIR:-/tmp}/sketchybar.network"

NWI="$(scutil --nwi)"
IP_ADDRESS="$(grep address <<<"$NWI" | sed 's/.*://' | tr -d ' ' | head -1)"
IS_VPN="$(grep -m1 utun <<<"$NWI")"

# The default route's interface is whatever carries user traffic right now:
# en0/en1 normally, utun* when a tunnel claims the default route.
IFACE="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"

RX=0
TX=0
if [ -n "$IFACE" ]; then
    read -r RX TX < <(netstat -ibn 2>/dev/null | awk -v i="$IFACE" '$1==i {print $7, $10; exit}')
    RX=${RX:-0}
    TX=${TX:-0}
fi

NOW=$(date +%s)
PREV_IFACE=""
PREV_T=0
PREV_RX=0
PREV_TX=0
if [ -f "$CACHE" ]; then
    read -r PREV_IFACE PREV_T PREV_RX PREV_TX <"$CACHE" 2>/dev/null
fi
printf '%s %s %s %s\n' "$IFACE" "$NOW" "$RX" "$TX" >"$CACHE"

human() {
    awk -v b="$1" 'BEGIN {
        split("B KiB MiB GiB TiB", u, " ")
        i = 1
        while (b >= 1024 && i < 5) { b /= 1024; i++ }
        if (i == 1) printf "%d %s", b, u[i]
        else        printf "%.1f %s", b, u[i]
    }'
}

# Reject deltas across interface flips, sleep gaps, or counter rollover.
DT=$((NOW - PREV_T))
DOWN_BPS=0
UP_BPS=0
if [ "$IFACE" = "$PREV_IFACE" ] && [ "$DT" -gt 0 ] && [ "$DT" -lt 60 ]; then
    [ "$RX" -ge "$PREV_RX" ] && DOWN_BPS=$(((RX - PREV_RX) / DT))
    [ "$TX" -ge "$PREV_TX" ] && UP_BPS=$(((TX - PREV_TX) / DT))
fi

if [ -n "$IS_VPN" ]; then
    ICON="􃔷"
    LABEL="VPN"
    ICON_COLOR="0xff${MAUVE}"
    LABEL_COLOR="0xff${WHITE}"
elif [ -n "$IP_ADDRESS" ]; then
    ICON="􀙇"
    LABEL=""
    ICON_COLOR="0xff${BLUE}"
    LABEL_COLOR="0xff${WHITE}"
else
    ICON="􀙈"
    LABEL="offline"
    ICON_COLOR="0xff${OVERLAY1}"
    LABEL_COLOR="0xff${OVERLAY1}"
fi

LABEL_DRAWING=on
[ -z "$LABEL" ] && LABEL_DRAWING=off

# Throughput is shown whenever we're connected. Idle traffic (mDNS, keepalives)
# reads as ~0 B/s and that's fine - constant items don't jitter neighbours.
THRU=off
if [ -n "$IS_VPN" ] || [ -n "$IP_ADDRESS" ]; then
    THRU=on
fi

sketchybar \
    --set network \
    icon="$ICON" \
    icon.color="$ICON_COLOR" \
    label="$LABEL" \
    label.color="$LABEL_COLOR" \
    label.drawing="$LABEL_DRAWING" \
    --set network.up \
    drawing="$THRU" \
    label="$(human "$UP_BPS")/s" \
    --set network.down \
    drawing="$THRU" \
    label="$(human "$DOWN_BPS")/s"
