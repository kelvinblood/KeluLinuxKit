#!/bin/bash

onlineCount=`/bin/netstat -ant | grep ESTABLISHED |wc -l`
onlinePPTP=`ifconfig | grep ppp | wc -l`
onlineSSH=`last | grep still | grep pts | wc -l`
onlineOther=`netstat -ant |grep ESTABLISHED | grep -v '1344' | grep -v '1723' |
wc -l`

echo "当前在线:$onlineCount  PPTP$onlinePPTP SSH$onlineSSH Other$onlineOther"
echo "ssh在线"

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

tmpSSHLoginMsg='/tmp/tmpSSHLoginMsg.tmp'
last | grep still | grep pts | awk '{print $1 " " $3 " " $7}'> $tmpSSHLoginMsg

# echo  "all msg:"
# cat $tmpSSHLoginMsg

while read loginMsg
do
        loginTime=`echo $loginMsg | cut -d ' ' -f 3`
        nowTime=`date +%H:%M`

        # echo "loginTime: $loginTime"
        # echo "nowTime: $nowTime"
        outputMsg=`echo $loginMsg | cut -d ' ' -f 1,2`
        echo -n "$outputMsg "
        timeCaculate $loginTime $nowTime
done < $tmpSSHLoginMsg

rm $tmpSSHLoginMsg
