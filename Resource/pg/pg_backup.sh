
#!/bin/sh

. /etc/profile

dt=$(date +%Y-%m-%d-%H%M)
pg_dump -F c -Z 9 -d vpn > /var/local/pg_dump/vpn.all.$dt.dump

