#!/bin/bash
#

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="DEBUG"

set -e

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

_usage() {
	echo
	echo "USAGE: $0 /target/path/"
}

logd "This is '$0'"

locate_config_file

echo
_pb_title
_pb "This is some test text."
_pb
_pb "Variables defined in the central config file:"
_pb
_pb "BACKUPTOOLS_INC:  $BACKUPTOOLS_INC"
_pb "BACKUP_D:         $BACKUP_D"
_pb "BAKDIR:           $BAKDIR"
_pb "RECIPIENTS:       $RECIPIENTS"
_pb_footer
