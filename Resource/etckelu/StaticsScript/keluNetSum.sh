#!/bin/bash

netLogFile='/var/log/keluNetWatch.log'
netLogFileTmp='/tmp/keluNetSumWatch.tmp'

if [ ! -e $netLogFile ]; then
    echo 'no statics'
else

#一个月内流量统计

    preferTime1=`date +%Y-%m`
    extraMsg=''
    sed -n "/$preferTime1/,$ p" $netLogFile > $netLogFileTmp
    if [ `cat $netLogFileTmp | wc -l` = 0 ]; then
        cp $netLogFile $netLogFileTmp
        extraMsg="没有本月数据"
    else
        extraMsg="$preferTime1网口统计:"
    fi
    awk -v nextraMsg="$extraMsg" '{x+=$4;x1+=$6;y+=$9;y1+=$11}END{ print nextraMsg,"\nTX/RX packets",x,"pps /",y,"pps\n\t ",x/NR,"p/s /",y/NR,"p/s\nTX/RX bytes:",x1/1024/1024,"GB /",y1/1024/1024,"GB\n\t  ",x1/NR,"kb/s /",y1/NR,"kb/s" }' $netLogFileTmp
    echo ''

#24小时内流量统计

    preferTime1=`date -d "-1 day" +%Y-%m-%d`
    preferTime2=`date -d "-1 day" +%H:%M`
    extraMsg=''
    sed -n "/$preferTime1\ $preferTime2/,$ p" $netLogFile > $netLogFileTmp
    if [ `cat $netLogFileTmp | wc -l` = 0 ]; then
        cp $netLogFile $netLogFileTmp
        extraMsg="统计数据未足够24小时,最新网口统计:"
    else
        # extraMsg="一小时内网口统计数据为:"
        extraMsg="网口统计最近24小时:"
    fi
    awk -v nextraMsg="$extraMsg" '{x+=$4;x1+=$6;y+=$9;y1+=$11}END{ print nextraMsg,"\nTX/RX packets",x,"pps /",y,"pps\n\t ",x/NR,"p/s /",y/NR,"p/s\nTX/RX bytes:",x1/1024/1024,"GB /",y1/1024/1024,"GB\n\t  ",x1/NR,"kb/s /",y1/NR,"kb/s\n" }' $netLogFileTmp

    #一小时内流量统计
    preferTime1=`date -d "-1 hour" +%Y-%m-%d`
    preferTime2=`date -d "-1 hour" +%H:%M`
    extraMsg=''
    sed -n "/$preferTime1\ $preferTime2/,$ p" $netLogFile > $netLogFileTmp
    if [ `cat $netLogFileTmp | wc -l` = 0 ]; then
        cp $netLogFile $netLogFileTmp
        extraMsg="统计数据未足够一小时,最新网口统计:"
    else
        # extraMsg="一小时内网口统计数据为:"
        extraMsg="网口统计最近60分钟:"
    fi
    awk -v nextraMsg="$extraMsg" '{x+=$4;x1+=$6;y+=$9;y1+=$11}END{ print nextraMsg,"\nTX/RX packets",x,"pps /",y,"pps\n\t ",x/NR,"p/s /",y/NR,"p/s\nTX/RX bytes:",x1/1024,"MB /",y1/1024,"MB\n\t  ",x1/NR,"kb/s /",y1/NR,"kb/s\n" }' $netLogFileTmp
fi

rm $netLogFileTmp
