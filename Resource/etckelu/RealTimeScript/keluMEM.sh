#!/bin/bash

echo `free -m|grep "-"|awk '{print "\t内存:已用"$3 "MB 空闲" $4 "MB"}'`
echo "======前五MEM======"
ps aux|grep -v PID|sort -rn -k +4|head -5|awk '{print $3 " " $4 " " $11}'
