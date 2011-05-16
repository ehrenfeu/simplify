#!/bin/sh
#

exit_usage() {
	echo "usage: $0 <devicename>"
	echo
	echo "    <devicename> -- e.g. 'sda'"
	echo
	exit 1
}

update_temp_hitachi() {
    TEMP="$(hdparm -H /dev/sda | grep celsius  | cut -d ':' -f 2 | xargs)"
}

if [ -z "$1" ] ; then
    exit_usage
fi

update_temp_hitachi
SLEEP=0 # remember sleep-state
OLD=$(grep "$1 " /proc/diskstats)
echo "drive temperature: $TEMP "
echo "state: $OLD"
echo

while true ; do
    sleep 600
    # sleep 6
    update_temp_hitachi
    NEW=$(grep " $1 " /proc/diskstats)
    DIFF=$(/bin/echo -e "${OLD}\n${NEW}" | uniq -u)
    OLD=$NEW
    if [ -z "$DIFF" ] ; then
        if [ "$SLEEP" -eq "0" ] ; then
            echo "$(date "+%F %R") issuing sleep (sleeping: YES) (temp: $TEMP)"
            echo "state: $OLD"
            echo
            SLEEP=1
            date "+%F %R" >> /tmp/issued_hdsleep
            hdparm -q -y /dev/$1
        fi # FIXME: make sure the disk has not been woken up without affecting "diskstats" !!
    else
        if [ "$SLEEP" -eq "1" ] ; then
            echo "$(date "+%F %R") disk woke up (sleeping: NO) (temp: $TEMP)"
            echo "state: $OLD"
            echo
            SLEEP=0
        fi
    fi
done
