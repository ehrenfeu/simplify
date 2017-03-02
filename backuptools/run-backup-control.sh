#!/bin/bash
#

set -e

# we expect a folder ".backuptools" in the home directory containing the
# configs, the function definitions and the backup plugin scripts:
CONF="${HOME}/.backuptools/configs/COMMON"
if ! [ -r "$CONF" ] ; then
    echo "ERROR: can't find backuptools config file '$CONF'!"
    exit 255
fi
source "$CONF"

# source the common functions
source "${HOME}/.backuptools/functions.inc.sh"

# export variables required by the plugin scripts below
export BACKUPTOOLS_INC PP_BOX_WIDTH


### <sanity>
_check_hostname
_check_target_path "${BAKDIR}"
### </sanity>

## run all scripts in the given directory
## NOTE: *not* using run-parts is done by intention since
##       they are incompatible between Debian <-> RHEL
for file in $(ls ${BACKUP_D}) ; do
	if _file_executable "${BACKUP_D}/$file" ; then
		${BACKUP_D}/$file "${BAKDIR}"
	fi
done
