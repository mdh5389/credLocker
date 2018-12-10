#!/bin/bash
echo "Encrypting..." >> output.txt
MEDIA=/media/$(hostname)/*

for file in $MEDIA/.lib/*.aes; do
	name=${file##*/};
	rm /ramdisk/${name%.aes}.txt;
done
umount $MEDIA/.lib
cryptsetup luksClose test1

rm /ramdisk/file.key
