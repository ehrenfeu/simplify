#!/bin/sh

if [ -n "$1" ] ; then
    ID=$(xm domid "$1")
else
    echo "usage: $0 <DomainName>"
    exit 1
fi

for VBD_ID in $(xenstore-list /local/domain/${ID}/device/vbd) ; do
    BACKEND=$(xenstore-read /local/domain/${ID}/device/vbd/${VBD_ID}/backend)
    XEN_DEV=$(xenstore-read ${BACKEND}/dev)
    BLK_DEV=$(xenstore-read ${BACKEND}/params)
    echo "${XEN_DEV} <-> ${BLK_DEV}"
done
