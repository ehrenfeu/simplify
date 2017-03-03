#!/bin/bash

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

_rsync="/usr/bin/rsync"
_timeout="/usr/bin/timeout"

set -e

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

_usage() {
	echo
	echo "USAGE: $0"
	echo
}

logd "This is '$0'"

locate_config_file

echo
_pb_title "rsync ($BAKSRC)"

_file_executable_or_exit "$_timeout"
_file_executable_or_exit "$_rsync"

############################

if ! [[ -d "$BAKSRC" || -d "$BAKDST" || -d "$RSYNC_OPTS" || -d "$LOGDST" ]] ; then
	echo "$0 error in config file, check specified options!"
	exit 1
fi

_check_target_path "${BAKDST}"

if [ -z "$LOGNAME" ] ; then
    LOGNAME="rsync"
fi
LOGTGT="${LOGDST}/${LOGNAME}-${DATEymd}.log"

logi "$_rsync $RSYNC_OPTS $BAKSRC $BAKDST"
logi

date >> "$LOGTGT"

_pb "Running rsync:"
_pb "  * options: $RSYNC_OPTS"
_pb "  * src: $BAKSRC"
_pb "  * dst: $BAKDST"
_pb

$_rsync $RSYNC_OPTS "$BAKSRC" "$BAKDST" >> "$LOGTGT"

date >> "$LOGTGT"

cat "$LOGTGT" | _pb_stdin
_pb_footer
