
#!/bin/sh

. /etc/profile

# 00 6  *   *   * sudo -u runner /var/local/cron/pg_dump_rsync.runner.sh >> /var/local/cron/pg_dump_rsync.log 2>&1
# 00 3 * * * sudo -u postgres /var/local/cron/pg_dump.postgres.sh >> /var/local/cron/pg_dump.postgres.log 2>&1

if [ `hostname` = 'tokyo' ]; then

    pg_dump -F c -Z 9 -d vpn > /var/local/pg_dump/vpn.all.$(date +%Y-%m-%d-%H%M).dump

else



fi
