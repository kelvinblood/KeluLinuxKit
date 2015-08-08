#!/bin/bash

clear
set -e


KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`

# # apt-get update
# sudo passwd root
# su -
# apt-get -y install zip
# wget https://github.com/kelvinblood/KeluLinuxKit/archive/master.zip
# unzip master.zip
# mv KeluLinuxKit-master/ KeluLinuxKit
# cd KeluLinuxKit

# pkill -kill -t pts/1命令踢出第一个用户。

echo "========================================================================="
echo "KeluLinuxKit V0.1 for Debian 8"
echo "KeluLinuxKit will install in this path: $KELULINUXKIT"
echo "A tool to install & config for iptables, git, maximum-awesome, etc."
echo "For more information please visit http://project.kelu.org/kelulinuxkit"
echo "========================================================================="

# Check if user is root
if [ $(id -u) != "0" ]; then
  echo "Warning: You should run this script as root user."
fi

cd /var/log
if [ ! -e daily-report ]; then
  mkdir daily-report
fi

cd $KELULINUXKIT
if [ ! -e Download ]; then
  mkdir Download
fi

# time zone
dpkg-reconfigure tzdata

# cp $RESOURCE/locale /etc/default/locale
dpkg-reconfigure locales

# .bashrc .input.rc
touch $HOME/.bashrc 
cat $RESOURCE/Home/.bashrc >> $HOME/.bashrc

cat >> $HOME/.inputrc << EOF
# Add by keluLI $CURTIME
set completion-ignore-case on
EOF

echo ''
echo ''
echo ''
echo "-- Basic info -----------------------------------------------------"
apt-get update && apt-get -y autoremove && apt-get -y upgrade
apt-get -y install vim git ruby zip tmux sudo git rake
# # apt-get -y install vim tmux build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev jwm xterm vnc4server iceweasel xrdp ttf-arphic-uming  xfonts-intl-chinese xfonts-wqy iftop mutt msmtp pptpd transmission-daemon git-man less liberror-perl libruby1.9.1 rsync ruby ruby1.9.1 zip exuberant-ctags
# 
echo ''
echo ''
echo ''
echo "-- awesome-tmux -----------------------------------------------------"
# pass the_silver_searcher install 
apt-get -y install build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
# awesome-tmux
cd $DOWNLOAD
if [ ! -e maximum-awesome-linux ]; then
  git clone https://github.com/justaparth/maximum-awesome-linux.git
fi
cd maximum-awesome-linux
rake

cp $DOWNLOAD/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome-linux/tmux.conf_backup
cp $RESOURCE/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome-linux/tmux.conf

# cp $RESOURCE/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome
# cp $RESOURCE/maximum-awesome-linux/.tmux* $HOME
# cp $RESOURCE/maximum-awesome-linux/.vimrc* $HOME
# cp $RESOURCE/maximum-awesome-linux/vimrc.bundles $DOWNLOAD/maximum-awesome-linux/vimrc.bundles

# git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
# rm -r $HOME/.vim/bundle/vim-snipmate

# tmux-powerline
cd $HOME
touch .tmux.conf.local

cd $DOWNLOAD
if [ ! -e tmux-powerline ]; then
  git clone https://github.com/erikw/tmux-powerline.git
fi
cp $DOWNLOAD/tmux-powerline/themes/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh_backup
cp $RESOURCE/tmux-powerline/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh
cat >> $DOWNLOAD/maximum-awesome-linux/tmux.conf<< EOF
# add by KeluLi
set-option -g status-left "#($DOWNLOAD/tmux-powerline/powerline.sh left)"
set-option -g status-right "#($DOWNLOAD/tmux-powerline/powerline.sh right)"
source-file ~/.tmux.conf.local
EOF
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
echo "1. # source ~/.bashrc"
echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle."
echo "3. edit your email account on $HOME/.msmtprc and $HOME/.muttrc if you havent add secret foler."
echo "4. check your github account by: ssh -T git@github.com"
echo "5. start tmux by running tn XXX, and attach by tt XXX, kill by tk XXX"
echo "6. edit your own iptables on /etc/iptables.test.rules and then running ip"
