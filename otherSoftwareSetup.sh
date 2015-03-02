#!/bin/bash

clear

KELULINUXKIT=$(pwd)
NOWTIME=$(date)
GITHUBNAME=''
GITHUBEMAIL=''
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"


# LNMP
echo "-- LNMP Install ------------------------------------------------------"
cd $HOME
wget -c http://soft.vpser.net/lnmp/lnmp1.1-full.tar.gz
tar zxf lnmp1.1-full.tar.gz
rm lnmp1.1-full.tar.gz
cd lnmp1.1-full
./debian.sh

./pureftpd.sh
cp $RESOURCE/pure-ftpd.conf /usr/local/pureftpd/pure-ftpd.conf
service pureftpd restart

cd $HOME
rm -rf /home/wwwroot/default/*
cp -R $HOME/tmp/home/wwwroot/* /home/wwwroot/
cp $HOME/tmp/usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf
cp -R $HOME/tmp/usr/local/nginx/conf/vhost /usr/local/nginx/conf/vhost
