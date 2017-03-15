#!/bin/bash

. /etc/profile

JSON_FILE=/var/local/ss-bash/ssmlt.json
USER_FILE=/var/local/ss-bash/ssusers
TMPL_FILE=/var/local/ss-bash/ssmlt.template

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
  scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets tokyo2:/etc/ppp/chap-secrets;
  scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets aliyun:/etc/ppp/chap-secrets;
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
  echo "2 $SSPDH:$SSPDM $SSPH:$SSPM "
  cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers $USER_FILE;
  create_json
  scp $JSON_FILE tokyo2:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE aliyun:/var/local/ss-bash/ssmlt.json;
fi

# heartbeat
REMOTEURL=$WECAT_MASTER_API"/pptp"
ifconfig=`ifconfig`;
type='heartbeat';
client='tokyo';

REMOTE_CONTENT="type=$type&client=$client&ifconfig=$ifconfig";
# REMOTERESULT=`curl -d "$REMOTE_CONTENT" $REMOTEURL`;
