#!/bin/sh
#

### autossh options
# -M 0 - don't monitor the connection (see manpage)
# -f   - go to background before running 'ssh'

### ssh options
# -C - compress all transferred data
# -D - "dynamic" application-level port forwarding (SOCKS5 proxy)
# -N - don't execute a remote command (we're just forwarding)

autossh -M 0 -f -C -N -D 2222 autossh-tunnel
