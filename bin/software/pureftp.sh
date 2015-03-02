#!/bin/bash

clear

KELULINUXKIT="$(pwd)/../../"
cd $KELULINUXKIT
KELULINUXKIT=$(pwd)
NOWTIME=$(date)
GITHUBNAME=''
GITHUBEMAIL=''
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"


# pureftpd
echo "-- pureftpd Install ------------------------------------------------------"
cd $HOME/lnmp1.1-full
./pureftpd.sh
cp $RESOURCE/pure-ftpd.conf /usr/local/pureftpd/pure-ftpd.conf
service pureftpd restart
