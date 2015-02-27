#!/bin/bash

logTime=`date +%Y-%m-%d-%H-%M`
logPath='/var/log'
backupPath='/root/Dropbox/Backup'
# backup log
function bklog() {
  backupPath='/root/Dropbox/BackupLog'
  cd $logPath;
  tar -czvf keluLog.tar.gz  keluNetWatch.log keluSysWatch.log pptpd.log pptpd.warn.log
  mv keluLog.tar.gz $backupPath/keluLog.$logTime.tar.gz
}

# backup system
function bksys() {
  backupPath='/root/Dropbox/BackupSysMirror'

  filename=`date +%Y-%m-%d`;
  tar cvpzf $backupPath/$filename.tar.gz --exclude=/proc --exclude=/lnmp1.1-full --exclude=/tmp --exclude=/lost+found --exclude=/mnt --exclude=/sys --exclude=/root/Dropbox --exclude=/pub --exclude=/root/Downloads --exclude=/var/lib/transmission-daemon/downloads --exclude=/var/lib/transmission-daemon/incomplete-downloads /;

}

bksys
#bklog
echo "$logTime backup complete" | tee -a $logPath/kelubk.log
