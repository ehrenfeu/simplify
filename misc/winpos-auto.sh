#!/bin/bash

# if FD 1 (stdout) is not a terminal / tty, redirect all output to a log file:
if ! test -t 1; then
    exec 1>"$HOME"/.winpos-auto.log
fi

export DISPLAY=:0.0

LASTLAYOUT_FILE="$HOME/.window_positions_lastlayout"
LAST_ACTIVE=$(cat "$LASTLAYOUT_FILE")

FULL_RES=$(wmctrl -d | head -n 1 | tr -s ' ' | cut -d ' ' -f 4)
if [ "$FULL_RES" == "2560x1440" ]; then
    LAYOUT="one_screen"
else
    LAYOUT="two_screens"
fi

if [ "$LAST_ACTIVE" != "$LAYOUT" ]; then
    echo "Desktop layout changed, loading positions..."
    "$HOME"/.local/bin/winpos-restore.sh
fi

# no matter what, always save the positions and update the last layout file:
"$HOME"/.local/bin/winpos-save.sh
