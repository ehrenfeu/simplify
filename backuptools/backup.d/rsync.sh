#!/bin/bash

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

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


############################

_rsync=$(_file_executable_or_exit "/usr/bin/rsync")
_timeout=$(_file_executable_or_exit "/usr/bin/timeout")

echo
_pb_title "rsync ($BAKSRC)"

if ! [[ -d "$BAKSRC" || -d "$BAKDST" || -d "$RSYNC_OPTS" || -d "$LOGDST" ]] ; then
	echo "$0 error in config file, check specified options!"
	exit 1
fi

_check_target_path "${LOGDST}"
if [ -z "$LOGNAME" ] ; then
    LOGNAME="rsync"
fi
LOGTGT="${LOGDST}/${LOGNAME}-${DATEymd}.log"
_exit_if_file_exists "$LOGTGT"

logi "$_rsync $RSYNC_OPTS $BAKSRC $BAKDST"
logi

date >> "$LOGTGT"

_pb "Running rsync:"
_pb "  * options: $RSYNC_OPTS"
_pb "  * src: $BAKSRC"
_pb "  * dst: $BAKDST"
_pb

_check_target_path "${BAKDST}"

set +e
$_rsync $RSYNC_OPTS "$BAKSRC" "$BAKDST" >> "$LOGTGT"
RET_BAKEXEC=$?
set -e

check_return_value $RET_BAKEXEC

date >> "$LOGTGT"

if [ -n "$DST_GROUP" ] ; then
    _pb
    _pb
    _pb "Running 'chgrp' on destination directory:"
    set +e
    chgrp -R "$DST_GROUP" "$BAKDST"
    RET_CHGRP=$?
    set -e
    check_return_value $RET_CHGRP
    _pb
fi

# now print the rsync details, in a sub-box:
_pb_footer
cat "$LOGTGT" | _pb_stdin

_pb_footer
