#!/bin/bash
#

[ -z "$PP_BOX_WIDTH" ] && PP_BOX_WIDTH="76"
LOG_VERBOSITY="WARN"

STORE="$1/mysql"

set -e

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

logd "This is '$0'"

locate_config_file

_usage() {
	echo
	echo "USAGE: $0 /target/path/"
}

# # # # # # # #

_mysqldump_bin=$(_file_executable_or_exit "mysqldump")
_timeout=$(_file_executable_or_exit "timeout")
_compress=$(_file_executable_or_exit "gzip")
_compress_suffix="gz"

echo
_pb_title

_check_target_path "${STORE}"


DMP_OPTS=""
# MySQL 5.1 and newer have the '--opt' switch on by default, which means:
# --add-drop-table --add-locks --create-options --disable-keys
# --extended-insert --lock-tables --quick --set-charset.
# specify databases to dump:
DMP_OPTS="$DMP_OPTS --all-databases"
# Continue even if an SQL error occurs during a table dump.
DMP_OPTS="$DMP_OPTS --force"
# just one row of data per INSERT statement (makes dumps more comparable)
DMP_OPTS="$DMP_OPTS --skip-extended-insert"
# Sort table rows by primary key or by its first unique index (SLOW!)
DMP_OPTS="$DMP_OPTS --order-by-primary"
# We're not using scheduled events, so exclude them drom dumping
DMP_OPTS="$DMP_OPTS --events --skip-events --ignore-table=mysql.event"

for IGN_TAB in $IGNORE_TABLES ; do
    DMP_OPTS="${DMP_OPTS} --ignore-table=${IGN_TAB}"
done

DMP_FILE="${STORE}/mysql-all-$DATEYmdHM.sql"

_exit_if_file_exists "$DMP_FILE"

logi "DUMP OPTIONS:"
logi "$DMP_OPTS"

_pb "doing a complete dump of *ALL* mysql-dbs..."
_pb

# kill the dumper if it has not finished after 5 minutes (600s):
set +e
$_timeout 600 $_mysqldump_bin -u$DB_USER -p$DB_PW $DMP_OPTS > $DMP_FILE
RET=$?
set -e

check_return_value "$RET"

compress_backup_file "$DMP_FILE"

_pb_footer
echo
