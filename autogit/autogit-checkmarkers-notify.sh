#!/bin/bash
#
# This script is intended to be run e.g. from a user's crontab to check if a
# marker file from the "autogit-commit" script exists. In case the marker is
# there, a message is sent to the desktop using the "notify-send" tool.

# set -x

# setting DISPLAY is required to make "notify-send" work from the crontab as
# it needs to figure out the dbus session address (can be overridden from the
# crontab entry if necessary)::
[ -z "$DISPLAY" ] && export DISPLAY=:0

MARKER_COMMIT="/tmp/autogit_commit_summary"
MARKER_PUSH="/tmp/autogit_push_failed"

if [ -s "$MARKER_COMMIT" ] ; then
	BODY="$(cat $MARKER_COMMIT)"
	notify-send --urgency=critical --icon=user-available "New autogit commit!" "$BODY"
fi

if [ -s "$MARKER_PUSH" ] ; then
	# show max the last 5 entries from the marker file:
	BODY="$(tail -n 5 $MARKER_PUSH)"
	notify-send --urgency=critical --icon=network-error-symbolic "autogit error!" "$BODY"
fi
