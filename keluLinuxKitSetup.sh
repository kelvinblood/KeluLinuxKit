#!/bin/bash

clear

KELULINUXKIT=$(pwd)
NOWTIME=$(date)
GITHUBNAME='kelvinblood'
GITHUBEMAIL='kelvinbloodzz@gmail.com'
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
echo "========================================================================="
echo "KeluLinuxKit V0.1 for Debian 7.8"
echo "KeluLinuxKit will install in this path: $KELULINUXKIT"
echo "A tool to install & config for git, maximum-awesome, etc."
echo "For more information please visit http://project.kelu.org/kelulinuxkit"
echo "========================================================================="

# Check if user is root
if [ $(id -u) = "0" ]; then
  echo "Warning: You should not be a root to run this script if you are not a root, press Enter to continue, any key to abort."
fi


if [ ! -e Download ]; then
  mkdir Download
fi

# apt-get update && apt-get -y upgrade
#
# # hostname
# echo "kelu.org" > /etc/hostname
# hostname -F /etc/hostname
#
# # time zone
# dpkg-reconfigure tzdata
#
# cp $RESOURCE/locale /etc/default/locale
# dpkg-reconfigure locales

# awesome-tmux
# cd $DOWNLOAD
# apt-get -y install git rake
# if [ ! -e maximum-awesome-linux ]; then
#   git clone https://github.com/justaparth/maximum-awesome-linux.git
# fi
# cd maximum-awesome-linux
# rake
# cp $RESOURCE/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome
# cp $RESOURCE/maximum-awesome-linux/.tmux.conf.local $HOME

# # git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
# echo "-- tmux-powerline install -----------------------------------------------------"
# cd $DOWNLOAD
# if [ ! -e tmux-powerline ]; then
#   git clone https://github.com/erikw/tmux-powerline.git
# fi
# cp $RESOURCE/tmux-powerline/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh
# cat >> $DOWNLOAD/maximum-awesome-linux/tmux.conf<< EOF

# set-option -g status-left "#($DOWNLOAD/tmux-powerline/powerline.sh left)"
# set-option -g status-right "#($DOWNLOAD/tmux-powerline/powerline.sh right)"
# source-file ~/.tmux.conf.local
# EOF

# rm -r $HOME/.vim/bundle/vim-snipmate

# ssh
# cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
# cp $RESOURCE/ssh/sshd_config /etc/ssh/sshd_config

# cd $HOME
# if [ ! -e .ssh ]; then
#   mkdir .ssh
# fi
# git config --global user.name "$GITHUBNAME"
# git config --global user.email "$GITHUBEMAIL"
# touch $HOME/.ssh/authorized_keys
# cat $RESOURCE/ssh/.ssh/authorized_keys >> $HOME/.ssh/authorized_keys


# echo "-- github install ------------------------------------------------------"
# # github
# cd $HOME
# if [ ! -e Workspace ]; then
#   mkdir Workspace
# fi
# ssh-keygen -t rsa -f github -C "$GITHUBEMAIL"

# ssh-agent bash
# ssh-agent -s
# ssh-add ~/.ssh/github
# ssh -T git@github.com

# cd $HOME/Workspace
# git clone git@github.com:kelvinblood/KeluMacKit.git
# git clone git@github.com:kelvinblood/kelvinblood.github.com.git

# # .bashrc # .input.rc
# if [ -s $HOME/.bashrc ]; then
#   mv $HOME/.bashrc $HOME/.bashrc.backup
# fi
# cp $RESOURCE/.bashrc $HOME

# cat >> $HOME/.inputrc << EOF
# # Add by keluLI $CURTIME
# set completion-ignore-case on
# EOF

# cd $RESOURCE/maximum-awesome-linux/
# cp .vimrc* .tmux* ~/
# cp KeluLinuxKit/Resource/maximum-awesome-linux/vimrc.bundles KeluLinuxKit/Download/maximum-awesome-linux/vimrc.bundles
# ./fixln.sh

# # iptables
# # PPTP
# # SysBackup
# # mutt & msmtp



# LNMP
# cd $DOWNLOAD
# wget -c http://soft.vpser.net/lnmp/lnmp1.1-full.tar.gz
# tar zxf lnmp1.1-full.tar.gz
# cd lnmp1.1-full
# ./debian.sh
#
#

# . $HOME/.bashrc
#



# echo "Install KeluLinuxKit 0.1 completed! enjoy it."
# echo "But still, you need to follow these steps with manual work."
# echo "1. edit your iTerm2 profile, e.g. http://blog.kelu.org/mac/2015/01/25/iterm2-2.html. "
# echo "  It will help you a wonderful sightseeing of iTerms."
# echo "2. adding plugin: Supertab neocomplcache. seeing more about how to manage plugin by Bundle"
# echo "3. some useful tools, e.g. [github.app](https://mac.github.com) "
