#!/bin/bash

cpuIdle=`top -n 1|grep Cpu|awk '{print $8}'`
cpuLoad=`echo "scal=2;100-$cpuIdle"|bc`
sysLoad=`uptime | cut -d , -f 3-`
printf "CPU: $cpuLoad%%$sysLoad\n";
echo "运行进程数:`ps aux|wc -l`"

echo "======前五CPU======"
ps aux|grep -v PID|sort -rn -k +3|head -5|awk '{print $3 " " $4 " " $11}'
