#!/usr/bin/env bash

# vm_stat reads kernel-maintained Mach VM counters directly (no sampling), so
# it's the cheapest source of memory state. "Memory Used" matches Activity
# Monitor: anonymous (app) + wired (kernel) + compressed pages. Inactive and
# cached pages are reclaimable so they count as available, not used.
TOTAL_BYTES=$(sysctl -n hw.memsize)
PERCENTAGE=$(vm_stat | awk -v total="$TOTAL_BYTES" '
    /page size of/                 { page_size = $8 }
    /Anonymous pages/              { anon = $3 }
    /Pages wired down/             { wired = $4 }
    /Pages occupied by compressor/ { compressed = $5 }
    END {
        used = (anon + wired + compressed) * page_size
        printf "%.0f", used * 100 / total
    }
')

sketchybar --set "$NAME" label="${PERCENTAGE}%"
