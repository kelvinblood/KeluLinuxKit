#!/bin/bash

clear
set -e


KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`


echo "-- security ------------------------------------------------------"
cd $HOME
# iptables
cp $RESOURCE/iptables.test.rules /etc
cp $RESOURCE/iptables /etc/network/if-pre-up.d/iptables
iptables -F

iptables-restore < /etc/iptables.test.rules
iptables-save > /etc/iptables.up.rules
 
echo ''
echo ''
echo ''
echo "-- xrdp Install ------------------------------------------------------"
apt-get -y install jwm xterm vnc4server iceweasel xrdp ttf-arphic-uming  xfonts-intl-chinese xfonts-wqy
# goto http://get.adobe.com/cn/flashplayer/
cp $RESOURCE/flash.x86_64.tar.gz /tmp
cd /tmp
tar -xzvf flash.x86_64.tar.gz > /dev/null
cp libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so
cp -r usr/* /usr/
service transmission-daemon restart
service ssh restart
