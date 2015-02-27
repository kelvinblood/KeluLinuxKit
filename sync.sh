#!/bin/bash
set -e

KELULINUXKIT="$HOME/KeluLinuxKit"
RESOURCE="$KELULINUXKIT/Resource"
DOWNLOAD="$KELULINUXKIT/Download"
SECRET="$RESOURCE/secret"

cd $HOME
cp .bashrc .inputrc .bash_profile $RESOURCE

# tmux
cp .tmux.conf.local .vimrc.bundles.local .vimrc.bundles.local $RESOURCE/maximum-awesome-linux

cp -R $DOWNLOAD/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome-linux/vim $DOWNLOAD/maximum-awesome-linux/vimrc $DOWNLOAD/maximum-awesome-linux/vimrc.bundles $RESOURCE/maximum-awesome-linux/

cp $DOWNLOAD/tmux-powerline/themes/default.sh $RESOURCE/tmux-powerline/default.sh


# PPTP
cp -R /etc/pptpd.conf /etc/ppp $RESOURCE/PPTP
mv $RESOURCE/PPTP/chap-secrets $SECRET

# iptables
cp /etc/iptables.test.rules $RESOURCE
cp /etc/network/if-pre-up.d/iptables /$RESOURCE

# ssh
cp -r $HOME/.ssh /etc/ssh/sshd_config $SECRET

# transmission
cp /etc/transmission-daemon/settings.json $RESOURCE/transmission-daemon/settings.json

# mail
cp $HOME/.muttrc $HOME/.msmtprc $SECRET
echo 'Sync done!'
