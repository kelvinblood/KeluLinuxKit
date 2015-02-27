#!/bin/bash

INTERVAL="10"  # update interval in seconds
logSysWatchFile='/var/log/keluSysWatch.log'
logSysWatchFileTmp='/tmp/keluSysWatch.tmp'

while true
do
    nowTime=`date +"%F %T"`
    cpuIdle=`iostat -c | sed -n '4p' | awk '{print $NF}'`
    cpuLoad=`echo "scal=2;100-$cpuIdle"|bc`

    iostat -x | grep xvda > $logSysWatchFileTmp
    ioReadRate=`cat $logSysWatchFileTmp | awk '{print $4}'`
    ioWriteRate=`cat $logSysWatchFileTmp | awk '{print $5}'`
    ioSumRate=`echo "scale=2;$ioReadRate+$ioWriteRate"|bc`;
    ioUtil=`cat $logSysWatchFileTmp | awk '{print $14}'`

    echo `free -m|grep "-"|awk '{print $3 " " $4}'` > $logSysWatchFileTmp
    memUsed=`cat $logSysWatchFileTmp | cut -d " " -f 1`
    memIdle=`cat $logSysWatchFileTmp | cut -d " " -f 2`

    echo "$nowTime CPU $cpuLoad% | MEM $memUsed MB | read $ioReadRate write $ioWriteRate totally $ioSumRate waste $ioUtil" >> $logSysWatchFile

    sleep $INTERVAL
done
