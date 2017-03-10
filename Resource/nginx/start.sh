#!/bin/sh

#如果出现“error while loading shared libraries: libdrizzle.so”，那么需要这个环境变量
#export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

base=`dirname $0`
$NGINX_HOME/sbin/nginx -p $base -c conf/nginx.conf
