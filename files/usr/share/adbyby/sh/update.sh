#!/bin/sh
wget -P /tmp http://update.adbyby.com/rule3/lazy.txt
wget -P /tmp http://update.adbyby.com/rule3/video.txt
cp -f /tmp/lazy.txt /usr/share/adbyby/data/
cp -f /tmp/video.txt /usr/share/adbyby/data/
rm /tmp/lazy.txt
rm /tmp/video.txt

