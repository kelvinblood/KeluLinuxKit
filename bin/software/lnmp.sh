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


# LNMP
echo "-- LNMP Install ------------------------------------------------------"
cd $HOME
wget -c http://soft.vpser.net/lnmp/lnmp1.1-full.tar.gz
tar zxf lnmp1.1-full.tar.gz
rm lnmp1.1-full.tar.gz
cd lnmp1.1-full
./debian.sh
