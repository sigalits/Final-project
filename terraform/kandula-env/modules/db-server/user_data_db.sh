#! /bin/bash
set -e
echo "****Mount /data"
sudo mkfs -t xfs /dev/xvds
mkdir /data
mount  /dev/xvds /data
echo "****add to fstab"
UUID=` blkid | grep xvds | awk  -F\" '{print $2}'\n`
echo "UUID=${UUID}  /data  xfs  defaults,nofail  0  2" |  tee -a /etc/fstab
