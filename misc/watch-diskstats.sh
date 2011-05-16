#!/bin/sh
#

exit_usage() {
	echo "usage: $0 <devicename>"
	echo
	echo "    <devicename> -- e.g. 'sda'"
	echo
	exit 1
}

if [ -z "$1" ] ; then
    exit_usage
fi

SLEEP=0 # remember sleep-state
OLD=$(grep "$1 " /proc/diskstats)
echo "state: $OLD"
echo

while true ; do
    sleep 60
    NEW=$(grep " $1 " /proc/diskstats)
    DIFF=$(/bin/echo -e "${OLD}\n${NEW}" | uniq -u)
    OLD=$NEW
    if [ -z "$DIFF" ] ; then
        if [ "$SLEEP" -eq "0" ] ; then
            echo "$(date "+%F %R") issuing hdsleep command (sleeping: YES)"
            echo "state: $OLD"
            echo
            SLEEP=1
            date "+%F %R" >> /tmp/issued_hdsleep
            hdparm -q -y /dev/$1
        fi
    else
        if [ "$SLEEP" -eq "1" ] ; then
            echo "$(date "+%F %R") disk woke up (sleeping: NO)"
            echo "state: $OLD"
            echo
            SLEEP=0
        fi
    fi
done
