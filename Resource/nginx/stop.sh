#!/bin/sh
base=`dirname $0`
$NGINX_HOME/sbin/nginx -p $base -s stop
