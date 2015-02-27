#!/bin/bash

INTERVAL="1"  # update interval in seconds
IF='eth0'
logSysWatchFile='/var/log/keluNetWatch.log'

while true
do
    R1=`cat /sys/class/net/eth0/statistics/rx_packets`
    T1=`cat /sys/class/net/eth0/statistics/tx_packets`
    R3=`cat /sys/class/net/eth0/statistics/rx_bytes`
    T3=`cat /sys/class/net/eth0/statistics/tx_bytes`
    sleep $INTERVAL
    R2=`cat /sys/class/net/eth0/statistics/rx_packets`
    T2=`cat /sys/class/net/eth0/statistics/tx_packets`
    TXPPS=`expr $T2 - $T1`
    RXPPS=`expr $R2 - $R1`
    R4=`cat /sys/class/net/eth0/statistics/rx_bytes`
    T4=`cat /sys/class/net/eth0/statistics/tx_bytes`
    TBPS=`expr $T4 - $T3`
    RBPS=`expr $R4 - $R3`
    TKBPS=`expr $TBPS / 1024`
    RKBPS=`expr $RBPS / 1024`

    nowTime=`date +"%F %T"`
    echo "$nowTime TX: $TXPPS p/s $TKBPS kb/s RX: $RXPPS p/s $RKBPS kb/s" >> $logSysWatchFile 2>&1
done
