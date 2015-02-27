#!/bin/bash

realTimeDir='/etc/kelu/RealTimeScript'

#CPU
$realTimeDir/keluCPU.sh
echo ''
$realTimeDir/keluMEM.sh
echo ''
$realTimeDir/keluIO.sh
echo ''
$realTimeDir/keluOnline.sh
echo "PPTP在线"
$realTimeDir/keluPPTPOnline.sh
