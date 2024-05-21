#!/bin/bash

function move_windows_matching() {
    WINDOW_IDS=$(wmctrl -l | grep -Ei "$1" | cut -d ' ' -f 1)
    DESKTOP=$2

    for WINDOW in $WINDOW_IDS; do
        wmctrl -t "$DESKTOP" -i -r "$WINDOW"
    done
}

function move_windows_to_builtin() {
    WINDOW_IDS=$(wmctrl -l | grep -Ei "$1" | cut -d ' ' -f 1)

    for WINDOW in $WINDOW_IDS; do
        wmctrl -i -r "$WINDOW" -e "$MVARG_BUILTIN"
    done
}

MVARG="0,2700,-1,-1,-1" # horizontal screen layout (default)
MVARG_BUILTIN="0,0,1440,-1,-1"
LAYOUT=$(wmctrl -d | head -n 1 | tr -s ' ' | cut -d ' ' -f 4)
if [ "$LAYOUT" == "3840x3600" ]; then
    MVARG="0,0,100,-1,-1" # vertical screen layout
    MVARG_BUILTIN="0,0,2200,-1,-1"
fi

# first, move all windows to the "main" (external) screen:
for WIN in $(wmctrl -l | cut -d ' ' -f 1); do
    wmctrl -i -r "$WIN" -e "$MVARG"
done

move_windows_to_builtin '(ferdi)'

move_windows_matching '(thunderbird|mail - |calendar - |Sign In —|IMCF Internal|IMCF ToDo)' 0
move_windows_matching '(VAMP Management Server|vamp|prometheus|ccm)' 1
move_windows_matching '(hrm-omero|hrm_omero|poetry|Huygens|omero|hrm|huygens)' 2
move_windows_matching '(pyppms|pumapy|poetry)' 3
move_windows_matching '(snijder)' 4
move_windows_matching '(amazon|dorando|nextcloud|sslconnection|cargo|esv|he1ix|raspberry|minio|restic|cloudflare|caddy)' 5
