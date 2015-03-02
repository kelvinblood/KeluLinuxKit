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


echo "-- github install ------------------------------------------------------"
# github
cd $HOME/.ssh
git config --global user.name "$GITHUBNAME"
git config --global user.email "$GITHUBEMAIL"
ssh-keygen -t rsa -f id_rsa -C "$GITHUBEMAIL"

ssh-agent bash
ssh-agent -s
ssh-add ~/.ssh/id_rsa
