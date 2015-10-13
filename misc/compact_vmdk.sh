#!/bin/bash

# NOTE:
# first, start up the VM, log in and fill the free space with zeros, e.g.:
# > cat /dev/zero > zero.fill ; sync ; sleep 1 ; sync ; rm -f zero.fill

# exit on any error:
set -e

VBOX_BASEDIR="$HOME/VirtualBox_VMs"
cd "$VBOX_BASEDIR"

VM_NAME="debian-7.8.0"
cd "$VM_NAME"

VMDK_NAME="$(ls *.vmdk -1 | head -n 1)"
VMDK_FULL="$VBOX_BASEDIR/$VM_NAME/$VMDK_NAME"
VDI_NAME="${VM_NAME}__VDI-TEMP.vdi"
VDI_FULL="$VBOX_BASEDIR/$VM_NAME/$VDI_NAME"

echo "reducing size of '$VMDK_FULL'"
ls -hs "$VMDK_FULL"
set -x

vboxmanage showvminfo "$VM_NAME"
vboxmanage storageattach "$VM_NAME" --storagectl SATA --port 0 --device 0 --type hdd --medium none
vboxmanage clonehd --format vdi "$VMDK_FULL" "$VDI_FULL"
# vboxmanage closemedium disk "$VMDK_FULL" --delete
vboxmanage closemedium disk "$VMDK_FULL"
mv -vi "$VMDK_FULL" "${VMDK_FULL}.orig"

vboxmanage modifyhd "$VDI_FULL" --compact
vboxmanage clonehd --format vmdk "$VDI_FULL" "$VMDK_FULL"
# vboxmanage closemedium disk "$VDI_FULL" --delete
vboxmanage closemedium disk "$VDI_FULL"

vboxmanage storageattach "$VM_NAME" --storagectl SATA --port 0 --device 0 --type hdd --medium "$VMDK_FULL"
