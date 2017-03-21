#!/bin/bash
#

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

STORE="$1/pgsql"

set -e

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

logd "This is '$0'"


# TODO: add instructions about permissions for pg_dumpall to README!!
locate_config_file

_usage() {
	echo
	echo "USAGE: $0 /target/path/"
}

# # # # # # # #

_pg_dump_bin=$(_file_executable_or_exit "pg_dumpall")
_timeout=$(_file_executable_or_exit "timeout")
_compress=$(_file_executable_or_exit "pbzip2")
_compress_suffix="bz2"

echo
_pb_title

_check_target_path "${STORE}"

DMP_FILE="${STORE}/pg_dumpall-$DATEYmdHM.sql"

_exit_if_file_exists "$DMP_FILE"

logi "DUMP OPTIONS:"
logi "$DMP_OPTS"

_pb "doing a complete dump of *ALL* postgres-dbs..."

# kill the dumper if it has not finished after 5 minutes (600s):
set +e
$_timeout 600 $_pg_dump_bin $DMP_OPTS > $DMP_FILE
RET=$?
set -e

check_return_value "$RET"

compress_backup_file "$DMP_FILE"

_pb_footer
echo
