#!/bin/bash
#


# first, set a default verbosity:
__LOG_LEVEL=30  # WARN

# next, evaluate if a verbosity level was requested (like this, it is possible
# to configure the loglevel by setting the var LOG_VERBOSITY *before* sourcing
# this file):
[ "$LOG_VERBOSITY" = "INFO" ] && __LOG_LEVEL=20
[ "$LOG_VERBOSITY" = "DEBUG" ] && __LOG_LEVEL=10

logc() {
    [ "$__LOG_LEVEL" -le 50 ] && echo "[CRITICAL] $*" || true
}

loge() {
    [ "$__LOG_LEVEL" -le 40 ] && echo "[ERROR] $*" || true
}

logw() {
    [ "$__LOG_LEVEL" -le 30 ] && echo "[WARN] $*" || true
}

logi() {
    [ "$__LOG_LEVEL" -le 20 ] && echo "[INFO] $*" || true
}

logd() {
    [ "$__LOG_LEVEL" -le 10 ] && echo "[DEBUG] $*" || true
}


set_logname() {
    # set the logname for a specific backup script by using the
    # naming convention (script name without ".sh" suffix):
    logd "$FUNCNAME()"
    LOGNAME="$(basename $0 | sed 's,\.sh$,,')"
    logd "LOGNAME: $LOGNAME"
}
