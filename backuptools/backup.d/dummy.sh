#!/bin/bash
#

PP_BOX_WIDTH="56"
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
_pb "Some dummy text."
_pb_footer
