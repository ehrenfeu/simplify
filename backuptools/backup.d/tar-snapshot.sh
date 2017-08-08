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

_tar=$(_file_executable_or_exit "/bin/tar")

echo
_pb_title "tar-snapshot ($BAKSRC)"

if ! [[ -d "$BAKSRC" || -d "$BAKDST" ]] ; then
	echo "$0 error in config file, check specified options!"
	exit 1
fi

set_logname
_check_target_path "${LOGDST}"
LOGTGT="${LOGDST}/${LOGNAME}-${DATEymd}.log"
_exit_if_file_exists "$LOGTGT"

date >> "$LOGTGT"

_pb "Running tar:"
_pb "  * options: $TAR_OPTS"
_pb "  * src: $BAKSRC"
_pb "  * dst: $BAKDST"
_pb

_check_target_path "${BAKDST}"


srcdir=$(basename $BAKSRC)

ARCHIVE="${BAKDST}/${srcdir}.$(_DATEYmdHM).tar.bz2"
_exit_if_file_exists "${ARCHIVE}"

cd "${BAKSRC}/.."
set +e
$_tar $TAR_OPTS $TAR_EXCLUDES \
    --listed-incremental="${BAKDST}/tar-snapshot-metadata" \
    --file="${ARCHIVE}" \
    "${srcdir}" >> "$LOGTGT"
RET_BAKEXEC=$?
set -e

check_return_value $RET_BAKEXEC

date >> "$LOGTGT"

# archive entries (dirs and files)
ENTRIES=$(tar tjf "${ARCHIVE}")
# determine number of all archive entries:
COUNT_ALL=$(echo "$ENTRIES" | wc -l)
# determine number of archived directories:
COUNT_DIR=$(echo "$ENTRIES" | grep '/$' | wc -l)

# if the number of archive-entries is the same than the number
# of archived directories, then we don't keep the archive
if test "$COUNT_ALL" -gt "$COUNT_DIR" ; then
    _pb
    _pb "'$srcdir': archived *${COUNT_ALL}* new files/dirs"
    _pb "   ($(basename ${ARCHIVE}))"
else
    rm "${ARCHIVE}"
    _pb "'$srcdir': no *new* files!"
fi

_pb_footer
