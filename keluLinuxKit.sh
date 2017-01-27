#!/bin/bash

clear
set -e

#apt-get -y install unzip
#wget https://github.com/kelvinblood/KeluLinuxKit/archive/master.zip
#unzip master.zip
#mv KeluLinuxKit-master/ KeluLinuxKit
#rm master.zip

VERSION=' Version 0.0.1, 2017-1-26, Copyright (c) 2017 kelvinblood';
SOURCE="${BASH_SOURCE[0]}"
KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`

while [ -h "$SOURCE" ]; do
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

usage () {
    cat $DIR/help
}

init() {
    cd $KELULINUXKIT
    if [ ! -e Download ]; then
      mkdir Download
    fi

    # time zone
    dpkg-reconfigure tzdata

    # cp $RESOURCE/locale /etc/default/locale
    dpkg-reconfigure locales

cat >> $HOME/.inputrc << EOF
# Add by keluLI $CURTIME
set completion-ignore-case on
EOF

cat >> $HOME/.bash_profile << EOF
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=
EOF

cat >> /etc/environment << EOF
LC_ALL="en_US.utf8"
EOF

    locale-gen zh_CN.UTF-8
    locale-gen
    apt-get update && apt-get -y autoremove && apt-get -y upgrade
    apt-get -y install vim git ruby zip sudo git rake htop iftop wget

    cp /etc/sysctl.conf /etc/sysctl.conf_backup
    cp $RESOURCE/sysctl.conf /etc
    sysctl -p
}

install_zsh() {
    apt-get -y install zsh tmux
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

}

install_() {
    cat $DIR/install_help.md
}


install_iptable() {
    cd $HOME
    # iptables
    cp $RESOURCE/iptables.test.rules /etc
    cp $RESOURCE/iptables /etc/network/if-pre-up.d/iptables
    iptables -F

    iptables-restore < /etc/iptables.test.rules
    iptables-save > /etc/iptables.up.rules
}

install_ss() {
    cd "/var/local" && git clone https://github.com/shadowsocks/shadowsocks.git && cd shadowsocks && git checkout master;
    apt-get install python-pip && pip install shadowsocks;
    cd "/var/local" && git clone https://github.com/hellofwy/ss-bash && cd ss-bash;
    echo '12345 123456 10737418240' > ssusers
}

##############################################################
if [ "$#" -eq 0 ]; then
    usage
    exit 0
fi
case $1 in
    -h|h|help )
        usage
        exit 0;
        ;;
    -v|v|version )
        echo $VERSION;
        exit 0;
        ;;
esac
if [ "$EUID" -ne 0 ]; then
    echo "必需以root身份运行，请使用sudo等命令"
    exit 1;
fi

case $1 in
    init )
        shift
        init
        ;;
    install )
        shift
        install_$1 $2 $3
        ;;
    * )
        usage
        ;;
esac
