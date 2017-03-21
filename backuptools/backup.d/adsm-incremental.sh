#!/bin/bash
#

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

set -e

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

logd "This is '$0'"

locate_config_file

# $DSMC has to be set in the config, so let's check it:
DSMC_EXEC=$(_file_executable_or_exit "$DSMC")

# # # # # # # #

tsm_client_incr() {
    for i in $(seq 1 10) ; do
        logi "calling '$DSMC_EXEC incr \"$*\"'"
        $DSMC_EXEC incr "$*"
    	STATUS="$?"
    	if test "$STATUS" != "0" ; then
    		loge "TSM-client returned status '$STATUS'"
    		loge "--> sleeping for 5 minutes, then trying again ($i/10)"
    	else
            logi "TSM client successfully finished (in attempt $i/10)"
    		break
    	fi
    	sleep 300
    done
}

# # # # # # # #

_check_target_path "${STORE}"

echo
_pb_title
_pb

if ! test "$(id -u)" == "0" ; then
    loge 'root privileges required, stopping!'
    exit 1
fi

### ! ! ! WARNING ! ! ! ###
# paths have to be specified *with* a trailing slash!!!
# otherwise the tsm-call takes ages and even misses new files!
tsm_client_incr "${STORE}/" | _pb_stdin

_pb_footer
