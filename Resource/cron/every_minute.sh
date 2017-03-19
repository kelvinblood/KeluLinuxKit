#!/bin/bash

. /etc/profile

JSON_FILE=/var/local/ss-bash/ssmlt.json
USER_FILE=/var/local/ss-bash/ssusers
TMPL_FILE=/var/local/ss-bash/ssmlt.template
SERVERNAME="tokyo"
IS_LOG=1

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

get_file_h(){
FILE=$1
NUM=`ls -l $FILE | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
echo $NUM
}

get_file_m(){
FILE=$1
NUM=`ls -l $FILE | awk '{print $(NF-1)}' | cut -d ':' -f 2`;
echo $NUM
}

cmp_file(){
FILE1=$1
FILE2=$2

H=`get_file_h $FILE1`;
M=`get_file_m $FILE1`;
DH=`get_file_h $FILE2`;
DM=`get_file_m $FILE2`;

# 默认需要更新
FLAG=0;
# 目标文件更新时间 大于 源文件,则不需要更新了。

# 目标文件小时小于源文件，则更新
if [ $H -gt $DH ]; then
    FLAG=1;
    # 文件更新小时相等，目标文件更新分钟小于源文件，需要改
  elif [ $DH -eq $H ]; then
    if [ $M -gt $DM ]; then
    FLAG=1;
    fi
fi

echo $FLAG;
}

ppp_to_client(){
echo 'check ppp'
PPP="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets";
PPPD="/etc/ppp/chap-secrets";

FLAG=`cmp_file $PPP $PPPD`;
if [ $FLAG -eq 1 ]; then
  touch $PPP
  cp $PPP $PPPD;
  cp $PPP /tmp/restart_ppp.tmp;

  scp $PPP tokyo2:/etc/ppp/chap-secrets;
  scp $PPP tokyo2:/tmp/restart_ppp.tmp;

  scp $PPP aliyun:/etc/ppp/chap-secrets;
  scp $PPP aliyun:/tmp/restart_ppp.tmp;
fi
}

ss_to_client(){
echo 'check ss'
SS="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers";
SSD="/var/local/ss-bash/ssusers";

FLAG=`cmp_file $SS $SSD`;
if [ $FLAG -eq 1 ]; then
  touch $SS
  cp $SS $USER_FILE;
  create_json
  scp $JSON_FILE tokyo2:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE tokyo2:/tmp/restart_ss.tmp;

  scp $JSON_FILE aliyun:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE aliyun:/tmp/restart_ss.tmp;
fi
}

check_if_update(){
    if [ -e /tmp/restart_ppp.tmp ]; then
        echo 'restart ppp';
        docker restart pptp;
        service pppd-dns restart
        service ipsec restart
        service xl2tpd restart
        rm /tmp/restart_ppp.tmp;
    fi

    if [ -e /tmp/restart_ss.tmp ]; then
        echo 'restart ss';
        docker restart ss;
        rm /tmp/restart_ss.tmp;
    fi
}

heartbeat(){
# heartbeat
REMOTEURL=$WECAT_MASTER_API"/pptp"
ifconfig=`ifconfig`;
type='heartbeat';
client=`hostname`;

REMOTE_CONTENT="type=$type&client=$client&ifconfig=$ifconfig";
# REMOTERESULT=`curl -d "$REMOTE_CONTENT" $REMOTEURL`;
}

if [ `hostname` = 'tokyo' ]; then
echo 'i am host';
ppp_to_client
ss_to_client
#heartbeat
# cmp_file /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets /etc/ppp/chap-secrets
fi

check_if_update
