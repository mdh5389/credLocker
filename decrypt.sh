#!/bin/bash

MEDIA=/media/$(hostname)/*
MP=$MEDIA/.lib
FS=$MEDIA/.fs
echo "Using $MP and $FS" > /usr/local/src/output.txt
echo $(ls $MEDIA) >> /usr/local/src/output.txt
if [ -f $FS ]; then 
  aescrypt -d -k $MEDIA/.hd.key -o /ramdisk/usb.key /usr/local/src/usb.key.aes

  cryptsetup -d /ramdisk/usb.key open --type luks $FS test1
  mount /dev/mapper/test1 $MP

  rm /ramdisk/usb.key

  aescrypt -d -k $MP/key.key -o /ramdisk/file.key /usr/local/src/file.key.aes

  for file in $MP/*.aes; do
	name=${file##*/};
	aescrypt -d -k /ramdisk/file.key -o /ramdisk/${name%.aes}.txt  $file
  done
  echo "Completed!" >> /usr/local/src/output.txt
else
  echo "Could not run decrypt" >> /usr/local/src/output.txt
fi

