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
    [ "$__LOG_LEVEL" -le 50 ] && echo "[CRITICAL] $*"
}

loge() {
    [ "$__LOG_LEVEL" -le 40 ] && echo "[ERROR] $*"
}

logw() {
    [ "$__LOG_LEVEL" -le 30 ] && echo "[WARN] $*"
}

logi() {
    [ "$__LOG_LEVEL" -le 20 ] && echo "[INFO] $*"
}

logd() {
    [ "$__LOG_LEVEL" -le 10 ] && echo "[DEBUG] $*"
}
