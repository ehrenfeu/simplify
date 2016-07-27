#!/bin/bash
#

# This script assumes special entries in /etc/hosts that are used to set up the
# required iptables rules to do a destination NAT to an ssh daemon running on
# some port number starting with 22. Every target host needs to be listed with
# its regular hostname and a special name defining the port. Assuming a
# hostname "myhostname" and the desired port "22001", the corresponding entry
# in the hosts file should look like this:
#
# 10.1.77.3   myhostname   ssh_dnat_port_22001

set -e

usage_exit() {
    echo "Usage: $0 [enable|disable|list] <targethostname>"
    echo
    exit ${1:-999}
}

list_colon22() {
    # disable "-e" inside this function as it would fail if no rules are
    # matching the "grep" pattern
    set +e
    echo "$1 rules containing ':22'"
    echo
    iptables --list | grep :22
    iptables --list --table nat | grep :22
    echo
    # re-enable "-e"
    set -e
}

if [ "$1" == "enable" ] ; then
    ACTION="--append"
elif [ "$1" == "disable" ] ; then
    ACTION="--delete"
elif [ "$1" == "list" ] ; then
    list_colon22 "Current"
    exit 0
else
    usage_exit 2
fi

if [ $# -ne 2 ] ; then
    usage_exit 1
fi

TGTHOST=$2

list_colon22 "Previous"

TGTIP=$(grep $TGTHOST /etc/hosts | cut -d ' ' -f 1)
TGTPORT=$(grep $TGTHOST /etc/hosts | sed -n 's,.*ssh_dnat_port_\([0-9]*\).*,\1,p')

echo "Target IP and port retrieved from /etc/hosts: $TGTIP:$TGTPORT"
echo

OPTS="--protocol tcp --dport $TGTPORT --in-interface eth0 --destination aldebaran"

iptables $ACTION INPUT $OPTS --match state --state NEW --jump ACCEPT
iptables $ACTION PREROUTING --table nat $OPTS --jump DNAT --to ${TGTIP}:${TGTPORT}

list_colon22 "New"
