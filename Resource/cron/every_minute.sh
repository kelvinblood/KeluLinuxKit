#!/bin/bash

. /etc/profile

PPPH=`ls -l /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
PPPM=`ls -l /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets | awk '{print $(NF-1)}' | cut -d ':' -f 2`;
PPPDH=`ls -l /etc/ppp/chap-secrets | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
PPPDM=`ls -l /etc/ppp/chap-secrets | awk '{print $(NF-1)}' | cut -d ':' -f 2`;

FLAG=1;
# 目标文件更新时间 大于 源文件
if [ $PPPDH -gt $PPPH ]; then
    FLAG=0;
    # 文件更新小时相等，目标文件更新分钟大于源文件，还是不需要改
  elif [ $PPPDH -eq $PPPH ]; then
    if [ $PPPDM -gt $PPPM ]; then
    FLAG=0;
    fi
fi

if [ $FLAG -eq 1 ]; then
  echo "1 $PPPDH $PPPDM $PPPH $PPPM "
  cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets /etc/ppp/chap-secrets;
  scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets fremont:/etc/ppp/chap-secrets;
fi

SSPH=`ls -l /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
SSPM=`ls -l /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers | awk '{print $(NF-1)}' | cut -d ':' -f 2`;

SSPDH=`ls -l /var/local/ss-bash/ssusers | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
SSPDM=`ls -l /var/local/ss-bash/ssusers | awk '{print $(NF-1)}' | cut -d ':' -f 2`;

FLAG=1;
# 目标文件更新时间 大于 源文件
if [ $SSPDH -gt $SSPH ]; then
    FLAG=0;
    # 文件更新小时相等，目标文件更新分钟大于源文件，还是不需要改
  elif [ $SSPDH -eq $SSPH ]; then
    if [ $SSPDM -gt $SSPM ]; then
    FLAG=0;
    fi
fi

if [ $FLAG -eq 1 ]; then
  echo `ps aux | grep '/usr/bin/python /usr/local/bin/ssserver -qq -c /var/local/ss-bash/ssmlt.json'|grep -v 'grep' | cut -d " " -f 6` > /var/local/ss-bash/tmp/ssserver.pid;

  echo "2 $SSPDH:$SSPDM $SSPH:$SSPM "
  cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers /var/local/ss-bash/ssusers;
  /var/local/ss-bash/ssadmin.sh soft_restart
fi



# heartbeat
REMOTEURL="$MASTER_API/pptp"
ifconfig=`ifconfig`;
type='heartbeat';
client='$CLIENT_NAME';

REMOTE_CONTENT="type=$type&client=$client&ifconfig=$ifconfig";
REMOTERESULT=`curl -d "$REMOTE_CONTENT" $REMOTEURL`;

