#!/bin/bash

iostat -x | grep xvda > /tmp/iostate.tmp;
ioReadRate=`cat /tmp/iostate.tmp | awk '{print $4}'`
ioWriteRate=`cat /tmp/iostate.tmp | awk '{print $5}'`
ioSumRate=`echo "scale=2;$ioReadRate+$ioWriteRate"|bc`;
ioUtil=`cat /tmp/iostate.tmp | awk '{print $14}'`
echo "总IO:$ioSumRate/s(读$ioReadRate写$ioWriteRate) 无效时间比$ioUtil"
