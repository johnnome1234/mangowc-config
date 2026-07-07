#!/bin/sh

for pid in $(pgrep -f "autostart.sh"); do
    if [ "$pid" != "$$" ] && [ "$pid" != "$PPID" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

pkill swaybg
swaybg -i ~/Pictures/nature1.jpg >/dev/null 2>&1 &
pkill -x qs; pkill -x quickshell
(while true; do quickshell -c ~/.config/quickshell >/dev/null 2>&1; sleep 1; done) &
