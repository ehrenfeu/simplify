#!/bin/bash

process_line() {
    WIN_ID=$(echo "$1" | cut -c -10)
    DESK_ID=$(echo "$1" | cut -c 12-13)
    # set -x
    printf -v WIN_POS_X '%d' $(echo "$1" | cut -c 15-18)
    printf -v WIN_POS_Y '%d' $(echo "$1" | cut -c 20-23)
    WIN_TITLE=$(echo "$1" | cut -c 44-)
    echo "$WIN_ID [$DESK_ID]@$WIN_POS_X/$WIN_POS_Y: $WIN_TITLE"
    if [ "$LAYOUT" == "two_screens" ]; then
        # move the window in X/Y position:
        wmctrl -i -r "$WIN_ID" -e "0,$WIN_POS_X,$WIN_POS_Y,-1,-1"
    fi
    # move it to the desired desktop number:
    wmctrl -t "$DESK_ID" -i -r "$WIN_ID"
    set +x
}

FULL_RES=$(wmctrl -d | head -n 1 | tr -s ' ' | cut -d ' ' -f 4)
if [ "$FULL_RES" == "2560x1440" ]; then
    echo "Using single (built-in only) screen layout..."
    LAYOUT="one_screen"
else
    echo "Using double (built-in + external) screen layout..."
    LAYOUT="two_screens"
fi
POSITIONS_FILE="$HOME/.window_positions_${LAYOUT}"
if ! [ -r "$POSITIONS_FILE" ]; then
    echo "ERROR: cannot find [$POSITIONS_FILE], stopping."
    exit 1
fi

while read -r LINE; do
    process_line "$LINE"
done <"$POSITIONS_FILE"
