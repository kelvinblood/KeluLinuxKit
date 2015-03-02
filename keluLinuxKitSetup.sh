#!/bin/bash

clear

KELULINUXKIT=$(pwd)
NOWTIME=$(date)
GITHUBNAME=''
GITHUBEMAIL=''
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"

# # apt-get update
# sudo passwd root
# su -
# apt-get -y install wget unzip
# wget https://github.com/kelvinblood/KeluLinuxKit/archive/master.zip
# unzip master.zip
# mv KeluLinuxKit-master/ KeluLinuxKit
# cd KeluLinuxKit

echo "========================================================================="
echo "KeluLinuxKit V0.1 for Debian 7.8"
echo "KeluLinuxKit will install in this path: $KELULINUXKIT"
echo "A tool to install & config for git, maximum-awesome, etc."
echo "For more information please visit http://project.kelu.org/kelulinuxkit"
echo "========================================================================="

# Check if user is root
if [ $(id -u) != "0" ]; then
  echo "Warning: You should be a root to run this script."
fi


if [ ! -e Download ]; then
  mkdir Download
fi

cd /etc
if [ ! -e kelu ]; then
  mkdir kelu
fi

cd $HOME
if [ ! -e Workspace ]; then
  mkdir Workspace
fi
if [ ! -e .ssh ]; then
  mkdir .ssh
fi
if [ ! -e Downloads ]; then
  mkdir Downloads
fi

cd /var/log
if [ ! -e daily-report ]; then
  mkdir daily-report
fi

cd $HOME
# hostname
echo "kelu.org" > /etc/hostname
hostname -F /etc/hostname

# time zone
dpkg-reconfigure tzdata

cp $RESOURCE/locale /etc/default/locale
dpkg-reconfigure locales

# ssh
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
cp $RESOURCE/sshd_config /etc/ssh/sshd_config

if [ -e $SECRET ]; then
cp -r $SECRET/.ssh $HOME
else
cd $HOME
mkdir .ssh
fi

# .bashrc .input.rc
if [ -s $HOME/.bashrc ]; then
  mv $HOME/.bashrc $HOME/.bashrc.backup
fi
cp $RESOURCE/.bashrc $HOME
cp $RESOURCE/.bash_profile $HOME

cat >> $HOME/.inputrc << EOF
# Add by keluLI $CURTIME
set completion-ignore-case on
EOF

cp -R $RESOURCE/etckelu/* /etc/kelu
echo ''
echo ''
echo ''
echo "-- Basic info -----------------------------------------------------"
apt-get update && apt-get -y upgrade
apt-get -y install vim tmux build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev jwm xterm vnc4server iceweasel xrdp ttf-arphic-uming  xfonts-intl-chinese xfonts-wqy iftop mutt msmtp pptpd transmission-daemon git-man less liberror-perl libruby1.9.1 rsync ruby ruby1.9.1 zip


echo ''
echo ''
echo ''
echo "-- awesome-tmux -----------------------------------------------------"
# apt-get -y install vim tmux build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
# awesome-tmux
cd $DOWNLOAD
apt-get -y install git rake
if [ ! -e maximum-awesome-linux ]; then
  git clone https://github.com/justaparth/maximum-awesome-linux.git
fi
cd maximum-awesome-linux
rake
cp $RESOURCE/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome
cp $RESOURCE/maximum-awesome-linux/.tmux* $HOME
cp $RESOURCE/maximum-awesome-linux/.vimrc* $HOME
cp $RESOURCE/maximum-awesome-linux/vimrc.bundles $DOWNLOAD/maximum-awesome-linux/vimrc.bundles
./fixln.sh

# git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
# rm -r $HOME/.vim/bundle/vim-snipmate

# tmux-powerline
cd $DOWNLOAD
if [ ! -e tmux-powerline ]; then
  git clone https://github.com/erikw/tmux-powerline.git
fi
cp $RESOURCE/tmux-powerline/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh
cat >> $DOWNLOAD/maximum-awesome-linux/tmux.conf<< EOF

set-option -g status-left "#($DOWNLOAD/tmux-powerline/powerline.sh left)"
set-option -g status-right "#($DOWNLOAD/tmux-powerline/powerline.sh right)"
source-file ~/.tmux.conf.local
EOF

echo "-- security ------------------------------------------------------"
cd $HOME
# iptables
cp $RESOURCE/iptables.test.rules /etc
cp $RESOURCE/iptables /etc/network/if-pre-up.d/iptables
iptables -F

iptables-restore < /etc/iptables.test.rules
iptables-save > /etc/iptables.up.rules

# PPTP
PPTP="$RESOURCE/PPTP"
# apt-get -y install pptpd
mv /etc/ppp /etc/ppp_backup
cp $PPTP/pptpd.conf /etc/pptpd.conf
cp -r $PPTP/ppp /etc
cp $KELULINUXKIT/secret/chap-secrets /etc/ppp/chap-secrets
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p
service pptpd restart

echo "-- Dropbox Install ------------------------------------------------------"
# dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# ~/.dropbox-dist/dropboxd
# /etc/kelu/dropbox.py

echo ''
echo ''
echo ''
echo "-- transmission Install ------------------------------------------------------"
# transmission
# apt-get -y install transmission-daemon
service transmission-daemon stop
cd $HOME/Downloads
if [ ! -e transmission-daemon ]; then
  mkdir transmission-daemon
  cd transmission-daemon
  mkdir downloads
  mkdir incomplete-downloads
fi
mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json_backup
cp $RESOURCE/transmission-daemon/settings.json /etc/transmission-daemon/settings.json
service transmission-daemon restart

echo ''
echo ''
echo ''
echo "-- xrdp Install ------------------------------------------------------"
# xrdp
# apt-get -y install jwm xterm vnc4server iceweasel xrdp ttf-arphic-uming  xfonts-intl-chinese xfonts-wqy
# goto http://get.adobe.com/cn/flashplayer/
cp $RESOURCE/flash.x86_64.tar.gz /tmp
cd /tmp
tar -xzvf flash.x86_64.tar.gz > /dev/null
cp libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so
cp -r usr/* /usr/


# mail
# apt-get -y install mutt msmtp
if [ -e $SECRET/.muttrc ]; then
cp $SECRET/.muttrc $SECRET/.msmtprc $HOME
else
cp $RESOURCE/.muttrc $RESOURCE/.msmtprc $HOME
fi

# cron
crontab /etc/kelu/keluCrontab
service cron restart

echo ''
echo ''
echo ''
echo "-- github install ------------------------------------------------------"
# github
cd $HOME/.ssh
git config --global user.name "$GITHUBNAME"
git config --global user.email "$GITHUBEMAIL"
ssh-keygen -t rsa -f id_rsa -C "$GITHUBEMAIL"

ssh-agent bash
ssh-agent -s
ssh-add ~/.ssh/id_rsa
exit

echo ''
echo ''
echo ''
echo "-- Almost done ------------------------------------------------------"
echo "Install KeluLinuxKit 0.1 completed! enjoy it."
echo "You have install those things: .bashrc .input.rc tmux iptables PPTP iftop"
echo " dropbox transmission xrdp mutt&msmtp cron github"
echo "But still, you need to follow these steps with manual work."
echo "1. dropbox authorized, by running ~/.dropbox-dist/dropboxd and then running /etc/kelu/dropbox.py start to sync"
echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle."
echo "3. edit your email account on $HOME/.msmtprc and $HOME/.muttrc if you havent add secret foler."
echo "4. check your github account by: ssh -T git@github.com"
echo "5. start tmux by running tn XXX, and attach by tt XXX, kill by tk XXX"
echo "6. edit your own iptables on /etc/iptables.test.rules and then running ip"
