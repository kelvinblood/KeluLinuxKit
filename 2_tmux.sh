#!/bin/bash

clear
set -e


KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`

#
# echo "-- security ------------------------------------------------------"
# cd $HOME
# # iptables
# cp $RESOURCE/iptables.test.rules /etc
# cp $RESOURCE/iptables /etc/network/if-pre-up.d/iptables
# iptables -F
# 
# iptables-restore < /etc/iptables.test.rules
# iptables-save > /etc/iptables.up.rules
# 
# # PPTP
# PPTP="$RESOURCE/PPTP"
# # apt-get -y install pptpd
# mv /etc/ppp /etc/ppp_backup
# cp $PPTP/pptpd.conf /etc/pptpd.conf
# cp -r $PPTP/ppp /etc
# # cp $KELULINUXKIT/secret/chap-secrets /etc/ppp/chap-secrets
# echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
# sysctl -p
# 
# #echo "-- Dropbox Install ------------------------------------------------------"
# ## dropbox
# #cd $HOME
# #if [ 32 == $LONGBIT ];then
# #  wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
# #else
# #  wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# #fi
# # ~/.dropbox-dist/dropboxd
# # /etc/kelu/dropbox.py
# 
# # echo ''
# # echo ''
# # echo ''
# # echo "-- transmission Install ------------------------------------------------------"
# # # transmission
# # # apt-get -y install transmission-daemon
# # service transmission-daemon stop
# # cd $HOME/Downloads
# # if [ ! -e transmission-daemon ]; then
# #   mkdir transmission-daemon
# #   cd transmission-daemon
# #   mkdir downloads
# #   mkdir incomplete-downloads
# # fi
# # mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json_backup
# # cp $RESOURCE/transmission-daemon/settings.json /etc/transmission-daemon/settings.json
# 
# # echo ''
# # echo ''
# # echo ''
# # echo "-- xrdp Install ------------------------------------------------------"
# # # xrdp
# # # apt-get -y install jwm xterm vnc4server iceweasel xrdp ttf-arphic-uming  xfonts-intl-chinese xfonts-wqy
# # # goto http://get.adobe.com/cn/flashplayer/
# # cp $RESOURCE/flash.x86_64.tar.gz /tmp
# # cd /tmp
# # tar -xzvf flash.x86_64.tar.gz > /dev/null
# # cp libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so
# # cp -r usr/* /usr/
# # 
# # 
# # # mail
# # # apt-get -y install mutt msmtp
# # if [ -e $SECRET/.muttrc ]; then
# # cp $SECRET/.muttrc $SECRET/.msmtprc $HOME
# # else
# # cp $RESOURCE/.muttrc $RESOURCE/.msmtprc $HOME
# # fi
# # 
# # # cron
# # crontab /etc/kelu/keluCrontab
# # 
# # service transmission-daemon restart
# # service cron restart
# service pptpd restart
# service ssh restart


echo ''
echo ''
echo ''
echo "-- Almost done ------------------------------------------------------"
echo "Install KeluLinuxKit 0.1 completed! enjoy it."
echo "But still, you need to follow these steps with manual work."
echo "1. cd tmux folder & rake install:solarized['dark']"
echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle."
# echo "3. edit your .tmux.conf file and set 'display-panes-time' with 'set-window-option -g display-panes-time 1500'. maybe on line 52"
# echo "4. check your github account by: ssh -T git@github.com"
echo "5. start tmux by running tn XXX, and attach by tt XXX, kill by tk XXX"
echo "6. edit your own iptables on /etc/iptables.test.rules and then running ip"
