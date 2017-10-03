#!/bin/bash
#

# set -x

MARKER="/tmp/autogit_push_failed"

if [ -s "$MARKER" ] ; then
	# show max the last 5 entries from the marker file:
	BODY="$(tail -n 5 $MARKER)"
	notify-send --urgency=critical --icon=network-error-symbolic "autogit error!" "$BODY"
fi