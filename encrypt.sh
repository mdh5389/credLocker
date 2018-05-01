#!/bin/bash

MEDIA=/media/$(hostname)/*

umount $MEDIA/.lib
cryptsetup luksClose test1

rm /ramdisk/file.key
