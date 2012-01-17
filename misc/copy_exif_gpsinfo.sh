#!/bin/bash
#
# script to copy the GPSInfo EXIF information from one file to another
#
# requires: exiv2, mktemp

exit_usage() {
    echo
    echo "USAGE: $0 <sourcefile> <targetfile>"
    echo
    exit 100
}

check_file() {
    if ! [ -r "$1" ] ; then
        echo "ERROR: can't read file '$1'"
        exit 101
    fi
}

if ! [ "$#" -eq '2' ] ; then
    exit_usage
fi

SRC="$1"
TGT="$2"

check_file "$SRC"
check_file "$TGT"

# exit if any of these commands fail:
set -e

# create a file to store the exiv2 'modify' commands
TMP=$(mktemp)

# fetch the metadata:
META="$(exiv2 -pv $SRC)"

COPYTAGS="GPSVersionID
GPSLatitudeRef
GPSLatitude
GPSLongitudeRef
GPSLongitude
GPSTimeStamp
GPSSatellites
GPSStatus
GPSMeasureMode
GPSDOP
GPSMapDatum
GPSProcessingMethod
GPSDateStamp"

for tag in $COPYTAGS ; do
    val="$(echo "$META" | grep " $tag " | cut -c 64-)"
    # echo "key: $tag value: $val"
    printf 'set Exif.GPSInfo.%s "%s"\n' "$tag" "$val" >> $TMP
done

# cat $TMP
exiv2 -v -m $TMP $TGT
rm $TMP
