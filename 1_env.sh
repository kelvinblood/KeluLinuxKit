#!/bin/bash

clear
set -e


KELULINUXKIT=$(pwd)
NOWTIME=$(date)
DOWNLOAD="$KELULINUXKIT/Download"
RESOURCE="$KELULINUXKIT/Resource"
SECRET="$RESOURCE/secret"
LONGBIT=`getconf LONG_BIT`

echo "========================================================================="
echo "KeluLinuxKit V0.1 for Debian 8"
echo "KeluLinuxKit will install in this path: $KELULINUXKIT"
echo "A tool to install & config for iptables, git, maximum-awesome, etc."
echo "For more information please visit http://project.kelu.org/kelulinuxkit"
echo "==========>>>>>>This script will reboot your server<<<<<================="
echo "========================================================================="

# Check if user is root
if [ $(id -u) != "0" ]; then
  echo "Warning: You should run this script as root user."
fi

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

# apt-get -y install zsh
# chsh -s /bin/zsh

echo "\n\n\n========================================================================="
echo "KeluLinuxKit V0.1 for Debian 8"
echo "install successfully, reboot now"
echo "=========================================================================\n\n\n"
reboot

