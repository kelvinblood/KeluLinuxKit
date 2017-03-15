#!/bin/bash

. /etc/profile

cd /var/local/fpm-pools/wechat/www/  && php artisan schedule:run
