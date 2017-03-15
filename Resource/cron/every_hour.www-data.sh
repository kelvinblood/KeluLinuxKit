#!/bin/bash

. /etc/profile

cd /var/local/fpm-pools/wechat/www/  && php artisan queue:restart >> /dev/null && (php artisan queue:work --daemon --tries=3>> /var/local/log/fpm-pools/wechat.queue.log 2>&1 &)
