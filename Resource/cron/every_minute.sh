#!/bin/bash

. /etc/profile

JSON_FILE=/var/local/ss-bash/ssmlt.json
USER_FILE=/var/local/ss-bash/ssusers
TMPL_FILE=/var/local/ss-bash/ssmlt.template
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
return `ls -l "$FILE" | awk '{print $(NF-1)}' | cut -d ':' -f 1`;
}

get_file_m(){
FILE=$1
return `ls -l "$FILE" | awk '{print $(NF-1)}' | cut -d ':' -f 2`;
}

cmp_file(){
FILE1=$1
FILE2=$2

PPPH=`get_file_h $FILE1`;
PPPM=`get_file_m $FILE1`;
PPPDH=`get_file_h $FILE2`;
PPPDM=`get_file_m $FILE2`;

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

return $FLAG;
}

ppp_to_client(){
PPP="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets";
PPPD="/etc/ppp/chap-secrets";

FLAG=`cmp_file $PPP $PPPD`;
if [ $FLAG -eq 1 ]; then
  echo "1 $PPPDH $PPPDM $PPPH $PPPM "
  cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets /etc/ppp/chap-secrets;
  scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets tokyo2:/etc/ppp/chap-secrets;
  scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets aliyun:/etc/ppp/chap-secrets;
fi
}

ss_to_client(){
SS="/var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers";
SSD="/var/local/ss-bash/ssusers";

FLAG=`cmp_file $PPP $PPPD`;
if [ $FLAG -eq 1 ]; then
  echo "2 $PPPDH $PPPDM $PPPH $PPPM "
  cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers $USER_FILE;
  create_json
  scp $JSON_FILE tokyo2:/var/local/ss-bash/ssmlt.json;
  scp $JSON_FILE aliyun:/var/local/ss-bash/ssmlt.json;
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

if [ `hostname` =eq "tokyo" ]; then
ppp_to_client
ss_to_client
fi
