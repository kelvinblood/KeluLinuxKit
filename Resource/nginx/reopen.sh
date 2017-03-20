#!/bin/sh
base=`dirname $0`

d=$(date +%Y-%m-%dT%T)
rename "s/\\.log/\\.${d}\\.bak/" $base/logs/*.log

$NGINX_HOME/sbin/nginx -p $base -s reopen
