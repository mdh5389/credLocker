#!/bin/bash

MEDIA=/media/$(hostname)/*
MP=$MEDIA/.lib
FS=$MEDIA/.fs

aescrypt -d -k $MEDIA/.hd.key -o /ramdisk/usb.key /usr/local/src/usb.key.aes

cryptsetup -d /ramdisk/usb.key open --type luks $FS test1
mount /dev/mapper/test1 $MP

rm /ramdisk/usb.key

aescrypt -d -k $MP/key.key -o /ramdisk/file.key /usr/local/src/file.key.aes

