#!/bin/sh
base=`dirname $0`
$NGINX_HOME/sbin/nginx -t -p $base -c conf/nginx.conf
