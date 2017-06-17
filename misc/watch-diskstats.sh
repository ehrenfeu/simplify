#!/bin/bash
#

exit_usage() {
	echo "usage: $0 <devicename>"
	echo
	echo "    <devicename> -- e.g. 'sda'"
	echo
	exit 1
}


update_temp_hitachi() {
    TEMP="$(hdparm -H /dev/$1 | grep celsius  | cut -d ':' -f 2 | xargs)"
}


update_temp_hddtemp() {
    TEMP="$(hddtemp /dev/$1 2>&1 | cut -d ':' -f 3)"
}


send_to_sleep() {
    # echo "debugging, not sending sleep command now..."
    # return
    update_temp_hddtemp $1
    echo "$(date "+%F %R") issuing sleep command (temp: $TEMP)"
    # echo "state: $OLD"
    echo
    LASTSTATE="sleeping"
    date "+%F %R" >> /tmp/issued_hdsleep
    hdparm -q -y /dev/$1
}


disk_woke_up() {
    LASTSTATE="spinning"
    update_temp_hddtemp $1
    echo "$(date "+%F %R") disk woke up (temp: $TEMP)"
    # echo "state: $OLD"
    echo
}


disk_is_spinning() {
    hdparm -C /dev/$1 | grep -qs 'active/idle'
}


diskstats_changed() {
    NEW=$(grep " $1 " /proc/diskstats)
    DIFF=$(/bin/echo -e "${OLD}\n${NEW}" | uniq -u)
    # if test -n "$DIFF" ; then
    #     echo "diskstats are differing!"
    #     echo $OLD
    #     echo $NEW
    # fi
    OLD=$NEW
    test -n "$DIFF"
}



if [ -z "$1" ] ; then
    exit_usage
fi



echo -n "$(date "+%F %R") current sleep state:"
hdparm -C /dev/$1 | tail -n 1 | cut -d ':' -f 2

if disk_is_spinning $1 ; then  # remember sleep-state
    LASTSTATE="spinning"
else
    LASTSTATE="sleeping"
fi
update_temp_hddtemp $1
OLD=$(grep "$1 " /proc/diskstats)
echo "drive temperature: $TEMP "
# echo "diskstats: $OLD"
echo "status: $LASTSTATE"
echo

while true ; do
    if disk_is_spinning $1 ; then
        if [ "$LASTSTATE" == "sleeping" ] ; then
            disk_woke_up $1
        fi
    fi
    if diskstats_changed $1 ; then
        if [ "$LASTSTATE" == "sleeping" ] ; then
            disk_woke_up $1
        fi
    else  # <-- diskstats are the same
        # only send the sleep command if the disk is not yet sleeping (i.e. was
        # in state "spinning" before):
        if [ "$LASTSTATE" == "spinning" ] ; then
            send_to_sleep $1
        fi
    fi
    sleep 600
    # sleep 30
    # sleep 10
done
