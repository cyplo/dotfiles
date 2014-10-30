#!/bin/bash

if [[ -z $1 ]]; then
    echo "usage: $0 device_to_clone"
    exit
fi

device=$1

timestamp=`date +%Y%m%d`
dest_file="/tmp/$timestamp.dd.xz"

echo "about to clone $device to $dest_file"
echo "ctrl-c or [enter]"
read

umount $device?
umount $device

sudo pv -tpreb $device | dd bs=4M | pixz > $dest_file

