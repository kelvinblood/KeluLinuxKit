#!/bin/bash

sysLogFile='/var/log/keluSysWatch.log'
sysLogFileTmp='/tmp/keluSysSumWatch.tmp'

echo '硬盘使用统计'
du --max-depth=1 -ah / 2> /dev/null | sort -hr | head -5
echo ''
if [ ! -e $sysLogFile ]; then
    echo 'no statics'
else

#一个月内CPU统计
    preferTime1=`date -d "-1 day" +%Y-%m-%d`
    preferTime2=`date -d "-1 day" +%H:%M`
    sed -n "/$preferTime1/,$ p" $sysLogFile > $sysLogFileTmp
    if [ `cat $sysLogFileTmp | wc -l` = 0 ]; then
        cp $sysLogFile $sysLogFileTmp
    fi
    extraMsg="系统本月状况"
    awk -v nextraMsg="$extraMsg" '{x+=$4;y+=$7;z1+=$11;z2+=$13;z3+=$17;}END{ print nextraMsg,"\nCPU(%) =",x/NR,"MEM(MB) =",y/NR,"MB\nIO(R/W)",z1/NR,z2/NR,"waste",z3/NR }' $sysLogFileTmp
    echo ''

#24小时内CPU统计
    preferTime1=`date -d "-1 day" +%Y-%m-%d`
    preferTime2=`date -d "-1 day" +%H:%M`
    sed -n "/$preferTime1\ $preferTime2/,$ p" $sysLogFile > $sysLogFileTmp
    if [ `cat $sysLogFileTmp | wc -l` = 0 ]; then
        cp $sysLogFile $sysLogFileTmp
    fi
    extraMsg="系统最近24小时:"
    awk -v nextraMsg="$extraMsg" '{x+=$4;y+=$7;z1+=$11;z2+=$13;z3+=$17;}END{ print nextraMsg,"\nCPU(%) =",x/NR,"MEM(MB) =",y/NR,"MB\nIO(R/W)",z1/NR,z2/NR,"waste",z3/NR }' $sysLogFileTmp
    echo ''

    #一小时内CPU统计
    preferTime1=`date -d "-1 hour" +%Y-%m-%d`
    preferTime2=`date -d "-1 hour" +%H:%M`
    extraMsg=''
    sed -n "/$preferTime1\ $preferTime2/,$ p" $sysLogFile > $sysLogFileTmp
    if [ `cat $sysLogFileTmp | wc -l` = 0 ]; then
        cp $sysLogFile $sysLogFileTmp
    fi
    extraMsg="系统最近60分钟:"
    awk -v nextraMsg="$extraMsg" '{x+=$4;y+=$7;z1+=$11;z2+=$13;z3+=$17;}END{ print nextraMsg,"\nCPU(%) =",x/NR,"MEM(MB) =",y/NR,"MB\nIO(R/W)",z1/NR,z2/NR,"waste",z3/NR }' $sysLogFileTmp
    echo ''
fi


rm $sysLogFileTmp
