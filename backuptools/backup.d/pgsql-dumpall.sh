#!/bin/bash
#

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

STORE="$1/pgsql"

_pg_dump_bin="/usr/bin/pg_dumpall"
_timeout="/usr/bin/timeout"
_compress="pbzip2"
_compress_suffix="bz2"

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

echo
_pb_title

_file_executable_or_exit "$_timeout"
_file_executable_or_exit "$_compress"
_file_executable_or_exit "$_pg_dump_bin"
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
