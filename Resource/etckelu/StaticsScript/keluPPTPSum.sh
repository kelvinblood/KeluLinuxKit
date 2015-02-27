#!/bin/bash

pptpLogFile='/var/log/pptpd.log'
pptpLogFileTmp='/tmp/onlinePPTPUp.tmp'
pptpLogFileTmp2='/tmp/onlinePPTPUp.tmp2'
pptpLogFileTmp3='/tmp/onlinePPTPUp.tmp3'
echo '' > $pptpLogFileTmp3
echo -n 'PPTP本月'
if [ -e $pptpLogFile ]; then
    nowTime=`date +%Y-%m`
    sed -n "/$nowTime/p" $pptpLogFile > $pptpLogFileTmp
    awk '{x+=$22}END{
        if ( x > 1024 ) { 
          printf " %.2fG\n",x/1024; 
        } else {
          printf " %.2fM\n",x; 
        }
      }' $pptpLogFileTmp
    pptpUserCount=`cat $pptpLogFileTmp | wc -l`
    pptpUserCountCircle=$pptpUserCount
    touch $pptpLogFileTmp3
    while [ $pptpUserCountCircle > 0 ];do
        # 获得用户名
        pptpUser=`head -n1 $pptpLogFileTmp | awk '{print $3}'`
        printf "%10s" $pptpUser >> $pptpLogFileTmp3

        # 删除源文件信息
        sed -n "/$pptpUser/p" $pptpLogFileTmp > $pptpLogFileTmp2
        sed -i "/$pptpUser/d" $pptpLogFileTmp

        perUserCount=`cat $pptpLogFileTmp2 | wc -l`
        printf " %-4s" $perUserCount >> $pptpLogFileTmp3
        # 计算总流量
        awk '{x+=$14;y+=$22}END{
        h=0;m=x;yGB=0;
        if(x > 60){
            h =int(x / 60);
            m =int(x % 60);
            printf " %2d时%.2d分",h,m,y;
        }
        else{
            m =int(x)
            printf "     %.2d分",m,y;
        }

        if(y > 1024){
          yGB=y / 1024;
          printf " %.2fG\n",yGB;
        }
        else{
          printf " %4dM\n",y;

        }
    }' $pptpLogFileTmp2 >> $pptpLogFileTmp3

    pptpUserCountCircle=`cat $pptpLogFileTmp | wc -l`

    if [ $pptpUserCountCircle = 0 ]; then
        sort -hr -k 4 $pptpLogFileTmp3
        break
    fi
    done
else
    echo '没有这个月的登陆信息'
fi


echo ''
echo -n "PPTP昨天"
echo '' > $pptpLogFileTmp3
if [ -e $pptpLogFile ]; then
    nowTime=`date -d "-1 day" +%F`
    sed -n "/$nowTime/p" $pptpLogFile > $pptpLogFileTmp
    awk '{x+=$22}END{ 
        if ( x > 1024 ) { 
          printf " %.2fG\n",x/1024; 
        } else {
          printf " %.2fM\n",x; 
        }
      }' $pptpLogFileTmp
    pptpUserCount=`cat $pptpLogFileTmp | wc -l`
    pptpUserCountCircle=$pptpUserCount
    while [ $pptpUserCountCircle > 0 ];do
        # 获得用户名
        pptpUser=`head -n1 $pptpLogFileTmp | awk '{print $3}'`
        printf "%10s" $pptpUser >> $pptpLogFileTmp3

        # 删除源文件信息
        sed -n "/$pptpUser/p" $pptpLogFileTmp > $pptpLogFileTmp2
        sed -i "/$pptpUser/d" $pptpLogFileTmp

        perUserCount=`cat $pptpLogFileTmp2 | wc -l`
        printf " %-4s" $perUserCount >> $pptpLogFileTmp3
        # 计算总流量
        awk '{x+=$14;y+=$22}END{
        h=0;m=x;yGB=0;
        if(x > 60){
            h =int(x / 60);
            m =int(x % 60);
            printf " %2d时%.2d分",h,m,y;
        }
        else{
            m =int(x)
            printf "     %.2d分",m,y;
        }

        if(y > 1024){
          yGB=y / 1024;
          printf " %.2fG\n",yGB;
        }
        else{
          printf " %4dM\n",y;

        }
    }' $pptpLogFileTmp2 >> $pptpLogFileTmp3

    pptpUserCountCircle=`cat $pptpLogFileTmp | wc -l`

    if [ $pptpUserCountCircle = 0 ]; then
        sort -hr -k 4 $pptpLogFileTmp3
        break
    fi
    done
else
    echo '没有今天登陆信息'
fi


echo ''
echo -n "PPTP今天"
echo '' > $pptpLogFileTmp3
if [ -e $pptpLogFile ]; then
    nowTime=`date +%F`
    sed -n "/$nowTime.*$nowTime/p" $pptpLogFile > $pptpLogFileTmp
    awk '{x+=$22}END{ 
        if ( x > 1024 ) { 
          printf " %.2fG\n",x/1024; 
        } else {
          printf " %.2fM\n",x; 
        }
      }' $pptpLogFileTmp
    pptpUserCount=`cat $pptpLogFileTmp | wc -l`
    pptpUserCountCircle=$pptpUserCount
    while [ $pptpUserCountCircle > 0 ];do
        # 获得用户名
        pptpUser=`head -n1 $pptpLogFileTmp | awk '{print $3}'`
        printf "%10s" $pptpUser >> $pptpLogFileTmp3

        # 删除源文件信息
        sed -n "/$pptpUser/p" $pptpLogFileTmp > $pptpLogFileTmp2
        sed -i "/$pptpUser/d" $pptpLogFileTmp

        perUserCount=`cat $pptpLogFileTmp2 | wc -l`
        printf " %-4s" $perUserCount >> $pptpLogFileTmp3
        # 计算总流量
        awk '{x+=$14;y+=$22}END{
        h=0;m=x;yGB=0;
        if(x > 60){
            h =int(x / 60);
            m =int(x % 60);
            printf " %2d时%.2d分",h,m,y;
        }
        else{
            m =int(x)
            printf "     %.2d分",m,y;
        }

        if(y > 1024){
          yGB=y / 1024;
          printf " %.2fG\n",yGB;
        }
        else{
          printf " %4dM\n",y;

        }
    }' $pptpLogFileTmp2 >> $pptpLogFileTmp3

    pptpUserCountCircle=`cat $pptpLogFileTmp | wc -l`

    if [ $pptpUserCountCircle = 0 ]; then
        sort -hr -k 4 $pptpLogFileTmp3
        break
    fi
    done
else
    echo '没有今天登陆信息'
fi


rm $pptpLogFileTmp $pptpLogFileTmp2 $pptpLogFileTmp3
