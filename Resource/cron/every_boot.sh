#!/bin/bash

. /etc/profile

service ipsec restart;
/var/local/nginx/start.sh;
php-fpm;


