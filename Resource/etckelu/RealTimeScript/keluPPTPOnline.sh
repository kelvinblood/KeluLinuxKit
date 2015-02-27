#!/bin/bash
File='/var/log/pptpd.log'
tmpPPTPCutFile='/tmp/pptpd.tail20-cut.tmp'
tmpPPTPOnlineFile='/tmp/pptpd.online.tmp'
logWarnFile='/var/log/pptpd.warn.log'
logoutTime=`date +"%F %T"`
onlinePPTP=`ifconfig | grep ppp | wc -l`

if [ ! -e $File ]; then
   echo "没有pptpd文件,不记录登出信息" 
else
    # 登陆数量
    cp $File $tmpPPTPCutFile
    awk '{FS=" "}$2==1{print $3 "\t" $8 "\t" $10}' $tmpPPTPCutFile > $tmpPPTPOnlineFile
fi

function timeCaculate()
{
  firstTime=$1
  secondTime=$2
  firstTimeH=`echo $firstTime | cut -d : -f 1`
  firstTimeM=`echo $firstTime | cut -d : -f 2`
  secondTimeH=`echo $secondTime | cut -d : -f 1`
  secondTimeM=`echo $secondTime | cut -d : -f 2`
  
  firstTimeMins=`expr $firstTimeH \* 60 + $firstTimeM`
  secondTimeMins=`expr $secondTimeH \* 60 + $secondTimeM`
  
  if [ $firstTimeMins -gt $secondTimeMins ]; then
    secondTimeMins=`expr $secondTimeMins + 24 \* 60`
  fi
  
  lastH=`expr \( $secondTimeMins - $firstTimeMins \) / 60`
  lastM=`expr \( $secondTimeMins - $firstTimeMins \) % 60`
  
  printf "(%.2d时%.2d分)\n" $lastH $lastM
}

# cat $tmpPPTPOnlineFile
countPPTP=`cat $tmpPPTPOnlineFile | wc -l`
if [ $onlinePPTP -ne $countPPTP ]; then
  echo "$logoutTime 有未注销的登陆，有异常" | tee -a $logWarnFile
fi
while read loginMsg
do
        loginTime=`echo $loginMsg | cut -d ' ' -f 3 | cut -d : -f 1,2`
        nowTime=`date +%H:%M`

        # echo "loginTime: $loginTime"
        # echo "nowTime: $nowTime"
        outputMsg=`echo $loginMsg | cut -d ' ' -f 1,2`
        echo -n "$outputMsg "
        timeCaculate $loginTime $nowTime
done < $tmpPPTPOnlineFile

rm -r $tmpPPTPOnlineFile $tmpPPTPCutFile
