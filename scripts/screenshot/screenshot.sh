#!/usr/bin/env bash

# Create directory if it doesn't exist
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

case "$1" in
    fullscreen)
        grim "$FILE"
        wl-copy -t image/png < "$FILE"
        notify-send -t 2000 "Screenshot" "Fullscreen saved and copied to clipboard" -i "$FILE"
        ;;
    region)
        geom=$(slurp)
        if [ -n "$geom" ]; then
            grim -g "$geom" "$FILE"
            wl-copy -t image/png < "$FILE"
            notify-send -t 2000 "Screenshot" "Region saved and copied to clipboard" -i "$FILE"
        fi
        ;;
    window)
        # Get active window geometry from mmsg
        geom=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"' 2>/dev/null)
        if [ -n "$geom" ] && [ "$geom" != "," ]; then
            grim -g "$geom" "$FILE"
            wl-copy -t image/png < "$FILE"
            notify-send -t 2000 "Screenshot" "Focused window saved and copied to clipboard" -i "$FILE"
        else
            # Fallback to region if no focused window is found or mmsg fails
            geom=$(slurp)
            if [ -n "$geom" ]; then
                grim -g "$geom" "$FILE"
                wl-copy -t image/png < "$FILE"
                notify-send -t 2000 "Screenshot" "Region saved and copied to clipboard" -i "$FILE"
            fi
        fi
        ;;
    clipboard)
        geom=$(slurp)
        if [ -n "$geom" ]; then
            grim -g "$geom" - | wl-copy -t image/png
            notify-send -t 2000 "Screenshot" "Copied region to clipboard"
        fi
        ;;
    *)
        echo "Usage: $0 {fullscreen|region|window|clipboard}"
        exit 1
        ;;
esac
