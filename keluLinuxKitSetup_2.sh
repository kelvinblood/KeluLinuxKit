#!/bin/bash

clear
set -e


KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`

echo ''
echo ''
echo ''
echo "-- Basic info -----------------------------------------------------"
apt-get update && apt-get -y autoremove && apt-get -y upgrade
apt-get -y install vim git ruby zip tmux sudo git rake htop iftop

# zsh重启生效引入zsh增强插件,支持git,rails等补全，可选多种外观皮肤
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

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

# rake install:solarized['dark']

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
set-window-option -g display-panes-time 1500
set-option -g status-left "#($DOWNLOAD/tmux-powerline/powerline.sh left)"
set-option -g status-right "#($DOWNLOAD/tmux-powerline/powerline.sh right)"
source-file ~/.tmux.conf.local
EOF

cat >> $HOME/.zshrc<< EOF
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=


alias vi='vim'
alias dd='df -h'
alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
alias p='netstat -antp'
alias pp='pstree -a'
alias ta='tail -f /var/log/syslog'
alias cdlog='cd /var/log'
alias ss='ssserver -c /etc/kelu/shadowsocksConfig.json -d'
alias k='/etc/kelu/keluReal.sh'
alias rm0='find / -type f -name "0" | xargs -i  rm -fr "{}"'
alias grepall='grep -D skip -nRe'
alias sour='source ~/.zshrc'

ip() {
  iptables -F;
  iptables-restore < /etc/iptables.test.rules;
  iptables-save > /etc/iptables.up.rules;
  iptables -L;
}

alias tn='tmux new -s'
alias tll='tmux ls'
alias tt='tmux attach -t'
alias tk='tmux kill-session -t'
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
echo "1. cd tmux folder & rake install:solarized['dark']"
echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle."
echo "3. edit your .tmux.conf file and set 'display-panes-time' with 'set-window-option -g display-panes-time 1500'. maybe on line 52"
# echo "4. check your github account by: ssh -T git@github.com"
echo "5. start tmux by running tn XXX, and attach by tt XXX, kill by tk XXX"
echo "6. edit your own iptables on /etc/iptables.test.rules and then running ip"