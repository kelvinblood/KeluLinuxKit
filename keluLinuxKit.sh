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

cd $KELULINUXKIT
if [ ! -e Download ]; then
  mkdir Download
fi

usage () {
    cat $DIR/help
}

init() {
    cd $KELULINUXKIT

    # time zone
    dpkg-reconfigure tzdata

    # cp $RESOURCE/locale /etc/default/locale
    dpkg-reconfigure locales

    cat $RESOURCE/Home/.inputrc >> $HOME/.inputrc
    cat $RESOURCE/Home/.bash_profile >> $HOME/.bash_profile
    cat $RESOURCE/Home/environment >> /etc/environment

    locale-gen zh_CN.UTF-8
    locale-gen
    apt-get update && apt-get -y autoremove && apt-get -y upgrade
    apt-get -y install vim git ruby zip sudo git rake htop iftop wget
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

    cat $RESOURCE/Home/.zshrc >> $HOME/.zshrc
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

init2() {
    cp /etc/sysctl.conf /etc/sysctl.conf_backup
    cp $RESOURCE/sysctl.conf /etc
    sysctl -p
}

install_ss() {
    cd "/var/local" && git clone https://github.com/shadowsocks/shadowsocks.git && cd shadowsocks && git checkout master;
    apt-get install python-pip && pip install shadowsocks;
    cd "/var/local" && git clone https://github.com/hellofwy/ss-bash && cd ss-bash;
    echo '12345 123456 10737418240' > ssusers

    # 开启hybla算法
    /sbin/modprobe tcp_hybla
    # 增加文件大小限制
    cat $RESOURCE/Home/limits.conf >> /etc/security/limits.conf

    ulimit -n 51200
}

install_pptp() {
    PPTP="$RESOURCE/pptp"
    apt-get -y install pptpd
    mv /etc/ppp /etc/ppp_backup
    cp $PPTP/pptpd.conf /etc/pptpd.conf
    cp -r $PPTP/ppp /etc
    service pptpd restart
}

install_l2tp() {
    cd $DOWNLOAD
    apt-get -y install ppp xl2tpd;
    wget https://download.openswan.org/openswan/openswan-2.6.49.tar.gz && tar -xzvf openswan-2.6.49.tar.gz && cd openswan-2.6.49 && make programs && make install;
}

test() {
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
