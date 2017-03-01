#!/bin/bash
#

locate_config_file() {
    # locate the configuration file for a specific backup script by using the
    # naming convention (script name without ".sh" suffix) and load it:
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

