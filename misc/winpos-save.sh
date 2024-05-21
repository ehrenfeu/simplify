#!/bin/bash

FULL_RES=$(wmctrl -d | head -n 1 | tr -s ' ' | cut -d ' ' -f 4)
if [ "$FULL_RES" == "2560x1440" ]; then
    LAYOUT="one_screen"
else
    LAYOUT="two_screens"
fi

POSITIONS_FILE="$HOME/.window_positions_${LAYOUT}"
LASTLAYOUT_FILE="$HOME/.window_positions_lastlayout"
echo "Saving current positions in [$POSITIONS_FILE]..."
wmctrl -l -G >"$POSITIONS_FILE"
echo "Saving current screen layout in [$LASTLAYOUT_FILE]..."
echo $LAYOUT >"$LASTLAYOUT_FILE"

