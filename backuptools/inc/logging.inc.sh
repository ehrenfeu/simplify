#!/bin/bash
#


# first, set a default verbosity:
__LOG_LEVEL=30  # WARN

# next, evaluate if a verbosity level was requested:
[ "$LOG_VERBOSITY" = "INFO" ] && __LOG_LEVEL=20
[ "$LOG_VERBOSITY" = "DEBUG" ] && __LOG_LEVEL=10

logw() {
    [ "$__LOG_LEVEL" -le 30 ] && echo "$*"
}

logi() {
    [ "$__LOG_LEVEL" -le 20 ] && echo "$*"
}

logd() {
    [ "$__LOG_LEVEL" -le 10 ] && echo "$*"
}
