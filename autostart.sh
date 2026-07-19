#!/bin/sh

for pid in $(pgrep -f "autostart.sh"); do
    if [ "$pid" != "$$" ] && [ "$pid" != "$PPID" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

pkill swaybg
swaybg -i ~/Pictures/nature2.jpg >/dev/null 2>&1 &
pkill -x qs; pkill -x quickshell
(while true; do
    if grep -q 'auto_scale = true' ~/.config/quickshell/config.toml 2>/dev/null; then
        MONITOR_HEIGHT=$(mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .height' 2>/dev/null)
        if [ -n "$MONITOR_HEIGHT" ] && [ "$MONITOR_HEIGHT" -gt 0 ]; then
            SCALE=$(awk "BEGIN {printf \"%.2f\", $MONITOR_HEIGHT / 1080}")
            export QT_SCALE_FACTOR=$SCALE
        else
            unset QT_SCALE_FACTOR
        fi
    else
        unset QT_SCALE_FACTOR
    fi
    quickshell -c ~/.config/quickshell >/dev/null 2>&1
    sleep 1
done) &
fish >/dev/null 2>&1 &
