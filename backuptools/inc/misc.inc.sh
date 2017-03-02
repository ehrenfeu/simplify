#!/bin/bash
#

locate_config_file() {
    # locate the configuration file for a specific backup script by using the
    # naming convention (script name without ".sh" suffix) and load it:
    logd "$FUNCNAME()"
    BASENAME="$(basename $0 | sed 's,\.sh$,,')"
    CONF="$HOME/.backuptools/configs/$BASENAME"
    if ! [ -f "$CONF" ] ; then
        loge "Can't read config file '$CONF'!"
        exit 100
    else
        logi "Sourcing config file '$CONF'!"
        source "$CONF"
    fi
}


check_return_value() {
    # check if the supplied value is '0' (success) or exit otherwise, printing
    # the corresponding success or error messages
    RET=$1
    if [ "$RET" -eq "0" ] ; then
        _pb "  --> SUCCESS!"
    else
        _pb
        _pb "       ****** ************* ******"
        _pb "  -->  ****** !!! ERROR !!! ******"
        _pb "       ****** ************* ******"
        _pb_footer
        exit 2
    fi
}


compress_backup_file() {
    if [ -z "$_compress" ] ; then
        logd "No compression tool configured, doing nothing."
        return
    fi
    _pb
    _pb "compressing file:"
    _compress "$1"
    _pb_file_with_size "${1}.$_compress_suffix"
}
