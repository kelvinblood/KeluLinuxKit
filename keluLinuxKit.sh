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
LOG_HOME=/var/local/log
DATA_HOME=/var/local/data
UPLOAD_HOME=/var/local/upload
PHP_HOME=/usr/share/php7
FPM_POOL_HOME=/var/local/fpm-pools
OPENRESTY_HOME=/usr/share/openresty
NGINX_HOME=/usr/share/openresty/nginx
NGINX_HOME_RUNTIME=/var/local/nginx
LD_LIBRARY_PATH=/usr/share/lib

JSON_FILE=/var/local/ss-bash/ssmlt.json
USER_FILE=/var/local/ss-bash/ssusers
TMPL_FILE=/var/local/ss-bash/ssmlt.template

LONGBIT=`getconf LONG_BIT`

IP=`ifconfig eth0 | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}'`

while [ -h "$SOURCE" ]; do
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $KELULINUXKIT
if [ ! -e Download ]; then
  mkdir -p Download
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
    apt-get -y install vim git ruby zip sudo git rake htop iftop iotop wget curl aptitude psmisc dbus

    mkdir -p /var/local/log
}

hostrenme(){
    hostnamectl set-hostname tokyo2
#    hostnamectl set-hostname tokyo2
}

test_all() {
    test_net
    echo -n "continue compute test?"
    read flag
    test_compute
}

test_net(){
    wget -qO- bench.sh | bash
}

test_compute(){
    wget --no-check-certificate https://github.com/teddysun/across/raw/master/unixbench.sh
    chmod +x unixbench.sh
    ./unixbench.sh
}

install_all() {
    init
    install_zsh
    install_iptable
    install_log
    install_bbr
#    install_openresty
#    install_docker
#    install_lnmp
#    install_l2tp
#    install_snmp
#    install_oneapm
    echo "install finish, install docker/crontab later by yourself, reboot"
    reboot
}

run_all(){
    run_nginx
    run_php
    run_docker_ss
#    run_docker_pptp
#    run_snmp
#    run_cron
}

install_log() {
        mkdir -p '/var/local/log'
        mkdir -p '/var/local/log/cron'
        mkdir -p '/var/local/log/wechat'
        mkdir -p '/var/local/log/wechat/ss'
}


install_supervisor() {
    cd /tmp
    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py

    pip install supervisor
    echo_supervisord_conf > /etc/supervisord.conf
    mkdir -p /etc/supervisor

    if [ ! -e '/var/local/log/supervisor' ]; then
        mkdir -p '/var/local/log/supervisor'
    fi
}

install_zsh() {
    apt-get -y install zsh tmux git
    # zsh重启生效引入zsh增强插件,支持git,rails等补全，可选多种外观皮肤
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

    echo ''
    echo ''
    echo ''
    echo "-- awesome-tmux -----------------------------------------------------"
    # pass the_silver_searcher install
    apt-get -y install build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev rake
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
# add by Kelu
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

    cp $RESOURCE/etc/sysctl.conf /etc
    sysctl -p
}

install_ss() {
    cd "/var/local" && git clone https://github.com/shadowsocks/shadowsocks.git && cd shadowsocks && git checkout master;
    apt-get install python-pip && pip install shadowsocks;
    cd "/var/local" && git clone https://github.com/hellofwy/ss-bash && cd ss-bash;
    echo '12345 123456 10737418240' > ssusers

    # 开启hybla算法
#    /sbin/modprobe tcp_hybla
    # 增加文件大小限制s
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

install_lnmp() {
    install_free
    install_pgsql
    install_openresty
    install_php
    install_composer
    install_personalproject
}

install_free(){
    dd  if=/dev/zero of=/swapfile bs=100M count=10;
    mkswap  /swapfile;
    swapon /swapfile;

cat >> /etc/rc.local << EOF
swapon /swapfile
EOF
}

install_personalproject(){
    echo 'sshd_conf';
    echo 'ssh config';
    echo 'git clone';
    echo 'cron';
    echo 'supervisor';
# * * * * * /var/local/cron/every_minute.sh >> /var/local/log/cron/every_minute.log 2>&1
# 0 * * * * /var/local/cron/every_hour.sh >> /var/local/log/cron/every_hour.log 2>&1
# 2 0 * * * /var/local/cron/every_day.sh >> /var/local/log/cron/every_day.log 2>&1
    echo 'sshd_conf';
    echo 'sshd_conf';
}

install_ssl(){
    echo ''
}

install_openresty(){
    cd $DOWNLOAD
    # aptitude -y install libreadline-dev libpcre3-dev libssl-dev libcloog-ppl0 libpq-dev
    aptitude -y install libreadline-dev libpcre3-dev libssl-dev libpq-dev
    wget https://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz
    tar -xzvf ngx_openresty-1.9.7.1.tar.gz
    rm -rf ngx_openresty-1.9.7.1.tar.gz
    cd ngx_openresty-1.9.7.1/
    hasIpv6=`ifconfig | grep "Scope:Global" | grep inet6 | wc -l`
    if [ $hasIpv6 -eq 0 ]; then
        ./configure --prefix=/usr/share/openresty --with-pcre-jit --with-http_postgres_module --with-http_iconv_module --with-http_stub_status_module
    else
        ./configure --prefix=/usr/share/openresty --with-pcre-jit --with-http_postgres_module --with-http_iconv_module --with-http_stub_status_module --with-ipv6
    fi

    make && make install
    rm -rf ngx_openresty-1.9.7.1

    mkdir -p /var/local/nginx
    mkdir -p /var/local/log/nginx
    cp -R $NGINX_HOME /var/local
    cd /var/local/nginx
    mkdir -p conf/vhost

    cp $RESOURCE/nginx/* /var/local/nginx/
}
install_php(){
    cd $DOWNLOAD
    aptitude -y install libssl-dev libcurl4-openssl-dev libbz2-dev libjpeg-dev libpng-dev libgmp-dev libicu-dev libmcrypt-dev freetds-dev libxslt-dev
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so
    ln -s /usr/lib/x86_64-linux-gnu/libct.a /usr/lib/libct.a
    ln -s /usr/lib/x86_64-linux-gnu/libct.so /usr/lib/libct.so
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

    wget http://am1.php.net/distributions/php-7.1.5.tar.gz
    tar -xzvf php-7.1.5.tar.gz
    cd php-7.1.5
    ./configure --prefix /usr/share/php7 --enable-fpm --enable-mysqlnd --enable-gd-native-ttf --enable-mbstring --enable-zip --enable-calendar --enable-bcmath --enable-exif --enable-intl --enable-opcache --enable-shmop --enable-soap --enable-sockets --with-fpm-user=www-data --with-fpm-group=www-data --with-pcre-regex --with-kerberos --with-openssl --with-mcrypt --with-zlib --with-bz2 --with-curl --with-gd --with-jpeg-dir=/usr/include/jpeg8 --with-png-dir=/usr/include/libpng12 --with-gettext --with-gmp --with-mhash --with-pgsql --with-pdo-pgsql --with-mysqli --with-pdo-mysql=mysqlnd --with-xsl
#    ./configure --prefix /usr/share/php5.6 --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-pcre-regex --with-openssl=shared --with-kerberos --with-zlib=shared --enable-bcmath=shared --with-bz2=shared --enable-calendar=shared --with-curl=shared --enable-exif=shared --with-gd=shared --with-jpeg-dir=/usr/include/jpeg8 --with-png-dir=/usr/include/libpng12 --with-gettext=shared --with-gmp=shared --with-mhash=shared --enable-intl=shared --enable-mbstring=shared --with-mcrypt=shared --enable-opcache --with-pdo-pgsql=shared --with-pgsql=shared --enable-shmop=shared --enable-soap=shared --enable-sockets=shared --with-xsl=shared --enable-zip=shared
    make clean && make && make install
    make test

    cp $RESOURCE/php/lib_php.ini /usr/share/php7/lib/php.ini
    cp $RESOURCE/php/etc_php-fpm.conf /usr/share/php7/etc/php-fpm.conf
    cp sapi/fpm/php-fpm /usr/share/php7/sbin/php-fpm

    mkdir -p /usr/share/php7/etc/pool
    cp $RESOURCE/php/etc_pool_www.conf /usr/share/php7/etc/pool/www.conf

    mkdir -p /var/local/log/fpm-pools/
    mkdir -p /var/local/fpm-pools/
    mkdir -p /var/local/fpm-pools/www/
    mkdir -p /var/local/fpm-pools/www/www
    mkdir -p /var/local/fpm-pools/www/www/public

    cp /var/local/nginx/html/index.html /var/local/fpm-pools/www/www/public/index.php

    ln -s /usr/share/php7/sbin/php-fpm /usr/local/bin/php-fpm
    ln -s /usr/share/php7/bin/php /usr/local/bin/php

}

install_pgsql(){
    cd $DOWNLOAD
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    apt-get -y install wget ca-certificates
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    apt-get update
    apt-get -y upgrade
    apt-get -y install postgresql-9.4 pgadmin3

    cd /var/local
    if [ ! -e '/var/local/pg_dump' ]; then
        mkdir -p '/var/local/pg_dump'
        chown postgres pg_dump
    fi

    cp $RESOURCE/pg/pg_hba.conf /etc/postgresql/9.4/main
    cp $RESOURCE/pg/postgresql.conf /etc/postgresql/9.4/main

    cd pg_dump
    cp $RESOURCE/pg/pg_backup.sh ./
    cp $RESOURCE/pg/pg_restore.sh ./
}

install_composer(){
    cd $DOWNLOAD
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
}

install_l2tp() {
    cd $DOWNLOAD
    apt-get -y install ppp xl2tpd libgmp3-dev gawk flex bison;
    wget https://download.openswan.org/openswan/openswan-2.6.49.1.tar.gz && tar -xzvf openswan-2.6.49.1.tar.gz && cd openswan-2.6.49.1 && make programs && make install;

    rm /etc/ipsec.conf;
cat >> /etc/ipsec.conf << EOF
version 2.0
config setup
    nat_traversal=yes
    virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12
    oe=off
    protostack=netkey

conn L2TP-PSK-NAT
    rightsubnet=vhost:%priv
    also=L2TP-PSK-noNAT

conn L2TP-PSK-noNAT
    authby=secret
    pfs=no
    auto=add
    keyingtries=3
    rekey=no
    ikelifetime=8h
    keylife=1h
    type=transport
    left=$IP
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any
    dpddelay=15
    dpdtimeout=30
    dpdaction=clear
EOF

    cd /etc
    if [ -e xl2tpd ]; then
        mv "/etc/xl2tpd" "/etc/xl2tpd_backup"
    fi

    cp -r "$RESOURCE/l2tp/xl2tpd" "/etc/xl2tpd"
    cp "$RESOURCE/l2tp/ppp/options.xl2tpd" "/etc/ppp/options.xl2tpd"
    cp $RESOURCE/ppp/chap-secrets /etc/ppp/chap-secrets
    touch /etc/ipsec.secrets
cat >> /etc/ipsec.secrets << EOF
$IP   %any:  PSK "jp.kelu.org"
EOF

    echo 1 > /proc/sys/net/ipv4/ip_forward
    for each in /proc/sys/net/ipv4/conf/*
    do
        echo 0 > $each/accept_redirects
        echo 0 > $each/send_redirects
    done

    ipsec setup start
#    ipsec verify
#    service ipsec restart
#    service pppd-dns restart
#    service xl2tpd restart
}

install_docker(){
    cd $DOWNLOAD
    apt-get -y install tcpdump curl
#    echo "deb http://http.debian.net/debian jessie-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
#    apt-get update
#    apt-get -t jessie-backports install linux-image-amd64
    curl -sSL https://get.docker.com/ | sh
    usermod -aG docker $USER
    systemctl enable docker
    systemctl start docker
#     update-rc.d docker enable
#     update-rc.d docker start
}

install_haproxy(){
    apt-get -y install haproxy
    cp $RESOURCE/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg;
    service haproxy start
}

install_keluwechat(){

    if [ ! -e '/var/local/log/cron' ]; then
        mkdir -p '/var/local/log/cron'
    fi

    if [ ! -e '/var/local/log/wechat' ]; then
        mkdir -p '/var/local/log/wechat'
    fi

    if [ ! -e '/var/local/log/wechat/ss' ]; then
        mkdir -p '/var/local/log/wechat/ss'
    fi

    install_docker
    install_docker_ss
    run_docker_ss
}

install_bbr(){
    cd $DOWNLOAD
    wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
    dpkg -i linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb

    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
}

install_snmp(){
    cd $DOWNLOAD
    apt-get -y install libperl-dev
    wget https://jaist.dl.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz
    tar -xzvf net-snmp-5.7.3.tar.gz
    cd net-snmp-5.7.3
    ./configure --prefix=/usr/local/snmp --with-mib-modules=ucd-snmp/diskio
    make
    make install
cat >> /usr/local/snmp/share/snmp/snmpd.conf << EOF
rouser snmpdjkb auth
EOF

    if [ ! -e '/var/net-snmp' ]; then
        mkdir -p '/var/net-snmp'
    fi

    touch '/var/net-snmp/snmpd.conf'
cat >> /var/net-snmp/snmpd.conf << EOF
createUser snmpdjkb MD5 snmpdjkb
EOF
}

install_docker_ss(){
    docker pull oddrationale/docker-shadowsocks;
    if [ ! -e "/var/local/ss-bash"  ]; then
        mkdir -p /var/local/ss-bash/
    fi
    cp $RESOURCE/docker/shadowsocks/ssmlt.json /var/local/ss-bash/ssmlt.json;
    mv /var/local/ss-bash/ssmlt.json /tmp/ssmlt.json
    cp $RESOURCE/docker/shadowsocks/ssmlt.json /var/local/ss-bash/ssmlt.json;

    docker run -d --name=ss --net=host -v /var/local/ss-bash/ssmlt.json:/tmp/ssmlt.json:rw oddrationale/docker-shadowsocks -c /tmp/ssmlt.json
}

install_vnc() {
  apt-get update
#  apt-get install -y xfce4 xfce4-goodies gnome-icon-theme tightvncserver xrdp
  apt-get install -y jwm xterm
  apt-get install -y ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4
  im-config -s ibus
  apt-get install -y ibus-pinyin
  systemctl enable xrdp

cat >> /root/.bashrc << EOF
export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH
EOF

  dpkg-reconfigure locales

  apt-get update
  apt-get install -y iceweasel ttf-wqy-zenhei

#cat >> /etc/apt/source.list << EOF
#deb http://dl.google.com/linux/chrome/deb/ stable main
#EOF

#  wget https://dl-ssl.google.com/linux/linux_signing_key.pub
#  apt-key add linux_signing_key.pub

#  apt-get install -y google-chrome-stable google-chrome-beta google-chrome-unstable chromium chromium-l10n
#  apt-get install -f
#  apt-get install -y google-chrome-stable google-chrome-beta google-chrome-unstable chromium chromium-l10n iceweasel ttf-wqy-zenhei
#  apt-get purge -y --auto-remove google-chrome-stable google-chrome-beta google-chrome-unstable chromium chromium-l10n iceweasel firefox firefox-esr

}
run_docker_ss(){
   docker run -d --name=ss --net=host -v /var/local/ss-bash/ssmlt.json:/tmp/ssmlt.json:rw oddrationale/docker-shadowsocks -c /tmp/ssmlt.json
#   docker run -d --name=ss --net=host -v /usr/share/bash/ssmlt.json:/tmp/ssmlt.json:rw oddrationale/docker-shadowsocks -c /tmp/ssmlt.json
}

run_snmp(){
    killall -9 snmpd
    /usr/local/snmp/sbin/snmpd
}

install_docker_pptp(){
    docker pull mobtitude/vpn-pptp;
    cp $RESOURCE/ppp/chap-secrets /etc/ppp
    cp /etc/ppp/chap-secrets /tmp
}

run_docker_pptp(){
    cp $RESOURCE/ppp/chap-secrets /etc/ppp
    cp /etc/ppp/chap-secrets /tmp
   docker run -d --name=pptp --privileged --net=host -v /etc/ppp/chap-secrets:/etc/ppp/chap-secrets:rw mobtitude/vpn-pptp
}

#install_docker_l2tp(){
#    docker pull fcojean/l2tp-ipsec-vpn-server
#    modprobe af_key
#    docker run --name l2tp --env-file /etc/ppp/l2tp.env -p 500:500/udp -p 4500:4500/udp -v /lib/modules:/lib/modules:ro -d --privileged fcojean/l2tp-ipsec-vpn-server
#
#    docker run --name l2tp --env-file /etc/ppp/l2tp.env --net=host -v /lib/modules:/lib/modules:ro -d --privileged fcojean/l2tp-ipsec-vpn-server
#}

run_cron(){
    cp -R $RESOURCE/cron /var/local
    # crontab -e
    # * * * * * /var/local/cron/every_minute.sh >> /var/local/cron/every_minute.log 2>&1
    # 0 * * * * /var/local/cron/every_hour.sh >> /var/local/cron/every_hour.log 2>&1
    # 1 * * * * /var/local/cron/every_hour.www-data.sh >> /var/local/cron/every_hour.log 2>&1
    # * * * * * /var/local/cron/every_minute.www-data.sh >> /var/local/cron/every_minute.log 2>&1
}

run_nginx(){
    cd /var/local/nginx
    ./test.sh
    ./start.sh
}

run_php(){
    /usr/share/php7/sbin/php-fpm
}

sync(){
    cp $RESOURCE/cron/every_minute.sh /var/local/cron/every_minute.sh

    if [ -e $HOME/.ssh/_ssh.tgz ]; then
        rm $HOME/.ssh/_ssh.tgz
    fi

    tar -czvf $HOME/.ssh/_ssh.tgz $HOME/.ssh/*

    scp $HOME/.ssh/_ssh.tgz tokyo2:/root
    scp /var/local/cron/every_minute.sh tokyo2:/var/local/cron/every_minute.sh
    scp /etc/hosts tokyo2:/etc/hosts

    scp $HOME/.ssh/_ssh.tgz hk1:/root
    scp /var/local/cron/every_minute.sh hk1:/var/local/cron/every_minute.sh
    scp /etc/hosts hk1:/etc/hosts

    scp $HOME/.ssh/_ssh.tgz aliyun:/root
    scp /var/local/cron/every_minute.sh aliyun:/var/local/cron/every_minute.sh
    scp /etc/hosts aliyun:/etc/hosts
}
check_if_update(){
    if [ -e /tmp/restart_ppp.tmp ]; then
        echo 'restart ppp';
        docker restart pptp;
        service pppd-dns restart
        service ipsec restart
        service xl2tpd restart
        rm /tmp/restart_ppp.tmp;
    fi

    if [ -e /tmp/restart_ss.tmp ]; then
        echo 'restart ss';
        docker restart ss;
        rm /tmp/restart_ss.tmp;
    fi
}

ppp_to_client(){
echo 'check ppp'
PPP="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets";
PPPD="/etc/ppp/chap-secrets";

  touch $PPP
  cp $PPP $PPPD;
  cp $PPP /tmp/restart_ppp.tmp;

  scp $PPP tokyo2:/etc/ppp/chap-secrets;
  scp $PPP tokyo2:/tmp/restart_ppp.tmp;

  scp $PPP aliyun:/etc/ppp/chap-secrets;
  scp $PPP aliyun:/tmp/restart_ppp.tmp;

  scp $PPP hk1:/etc/ppp/chap-secrets;
  scp $PPP hk1:/tmp/restart_ppp.tmp;
}

ss_to_client(){
echo 'check ss'
SS="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers";
SSD="/var/local/ss-bash/ssusers";

  touch $SS
  cp $SS $USER_FILE;
  create_json
  scp $JSON_FILE tokyo2:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE tokyo2:/tmp/restart_ss.tmp;

  scp $JSON_FILE aliyun:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE aliyun:/tmp/restart_ss.tmp;

  scp $JSON_FILE hk1:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE hk1:/tmp/restart_ss.tmp;
}
create_json () {
    echo '{' > $JSON_FILE.tmp
    sed -E 's/(.*)/    \1/' $TMPL_FILE >> $JSON_FILE.tmp
    awk '
    BEGIN {
        i=1;
        printf("    \"port_password\": {\n");
    }
    ! /^#|^\s*$/ {
        port=$1;
        pw=$2;
        ports[i++] = port;
        pass[port]=pw;
    }
    END {
        for(j=1;j<i;j++) {
            port=ports[j];
            printf("        \"%s\": \"%s\"", port, pass[port]);
            if(j<i-1) printf(",");
            printf("\n");
        }
        printf("    }\n");
    }
    ' $USER_FILE >> $JSON_FILE.tmp
    echo '}' >> $JSON_FILE.tmp
    mv $JSON_FILE.tmp $JSON_FILE
}

install_oneapm(){
    cd $DOWNLOAD
    CI_LICENSE_KEY=KEY bash -c "$(curl -L https://download.oneapm.com/oneapm_ci_agent/install_agent.sh)";
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
    run )
        shift
        run_$1 $2 $3
        ;;
    test )
        shift
        test_$1 $2 $3
        ;;
    sync )
        shift
        sync
        ss_to_client
        ppp_to_client
        ;;
    * )
        usage
        ;;
esac
