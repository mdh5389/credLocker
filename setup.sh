#!/bin/bash

MEDIA=/media/$(hostname)/*
FS=$MEDIA/.fs
MP=$MEDIA/.lib

SIZE=1610612736 #1.5 GiB

PWD=$(pwd)

if [[ ! -d $MOUNT ]]; then
    echo "Making mount point..."
    mkdir $MOUNT
fi      

if [[ ! -e $FS ]]; then
    echo "Making file system..."
    touch $FS
    shred -s $SIZE -n 3 -z -v $FS
    mkfs.fat $FS
fi      

for key in {key,usb,hd,file}.key; do
    aescrypt_keygen -g 256 /ramdisk/$key
done

aescrypt -e -k /ramdisk/key.key -o $PWD/file.key.aes /ramdisk/file.key
aescrypt -e -k /ramdisk/hd.key -o $PWD/usb.key.aes /ramdisk/usb.key

cryptsetup -d /ramdisk/usb.key luksFormat $FS
cryptsetup -d /ramdisk/usb.key --type luks $FS test1

dd if=/dev/zero of=/dev/mapper/test1
mkfs.fat /dev/mapper/test1

mount /dev/mapper/test1 $MP

mv /ramdisk/key.key $MP
mv /ramdisk/hd.key $ROOT/.hd.key

