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

if [ ! -d /etc/update-motd.d ]; then
  mkdir /etc/update-motd.d
fi

if [ ! -d /etc/update-motd-static.d ]; then
  mkdir /etc/update-motd-static.d
fi

# Either run these
if [ -f /run/motd.dynamic ]; then
  rm /run/motd.dynamic
fi

if [ -f /run/motd ]; then
  rm /etc/motd
fi

if [ -f /run/motd.tail ]; then
  rm /etc/motd.tail
fi

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
crontab -l > /tmp/mycron || touch /tmp/mycron
cat <<EOF >> /tmp/mycron
# update the 'static' parts of message of the day, every hour
0 * * * * run-parts /etc/update-motd-static.d
EOF
crontab /tmp/mycron
rm /tmp/mycron
