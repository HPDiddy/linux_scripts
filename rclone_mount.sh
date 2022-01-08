#!/bin/sh
#This script was created by https://github.com/HPDiddy and is used for mounting a rclone drive
if [ -f $USER/.config/rclone/rclone.conf ]
then
	echo "mounting drive..."
	sleep 3
	if [ -f $USER/mnt/gdrive ]
	then
rclone mount gcrypt: ~/mnt/gdrive --allow-other --allow-non-empty --cache-db-purge --buffer-size 32M --use-mmap --dir-cache-time 72h --drive-chunk-size 16M  --timeout 1h  --vfs-cache-mode writes --vfs-read-chunk-size 128M --vfs-read-chunk-size-limit 1G &
fi
sleep 2
echo "Drive mounted at $USER/mnt/gdrive"
else
	echo "Could not mount drive"
fi
