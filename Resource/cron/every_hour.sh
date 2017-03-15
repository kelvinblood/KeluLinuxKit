#!/bin/bash

. /etc/profile

cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets /etc/ppp/chap-secrets;
scp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/chap-secrets fremont:/etc/ppp/chap-secrets;
cp /var/local/fpm-pools/wechat/www/storage/app/vpn/ppp/ssusers /var/local/ss-bash/ssusers;
/var/local/ss-bash/ssadmin.sh soft_restart

php artisan queue:restart >> /dev/null
(php artisan queue:work --daemon --tries=3>> /var/local/log/wechat.queue.log 2>&1 &)
