#!/bin/bash

# This script is simply an installation "package" for anita2r's excellent
# "Dynamic Message of the Day" scripts for the Raspberry Pi
# from https://www.raspberrypi.org/forums/viewtopic.php?t=110617&p=759537
# 
# All credit goes to her!
#
# Patrick+

# On my latest installation of Raspbian, update-notifier-common was already installed.
# You should run these commands by hand preferably.

#apt-get update
#apt-get upgrade
#apt-get install update-notifier-common

mkdir /etc/update-motd.d
mkdir /etc/update-motd-static.d

# Either run these
rm /run/motd.dynamic
rm /etc/motd
rm /etc/motd.tail

# or these:
#mv /run/motd.dynamic /run/motd.dynamic.old
#mv /etc/motd /etc/motd.old
#mv /etc/motd.tail /etc/motd.tail.old

ln -s /run/motd /etc/motd

cp 10-load-avg /etc/update-motd.d/10-load-avg
cp 90-footer /etc/update-motd.d/90-footer

touch /etc/update-motd.d/00-header
touch /etc/update-motd.d/15-disk-space
touch /etc/update-motd.d/20-packages

chmod 0740 /etc/update-motd.d/*

cp 00-header /etc/update-motd-static.d/00-header
cp 15-disk-space /etc/update-motd-static.d/15-disk-space
cp 20-packages /etc/update-motd-static.d/20-packages

#Create a cron entry for the new motd files
crontab -l > /tmp/mycron
echo << EOF >> /tmp/mycron
# update the 'static' parts of message of the day, every hour
0 * * * * run-parts /etc/update-motd-static.d
EOF
crontab /tmp/mycron
rm /tmp/mycron
