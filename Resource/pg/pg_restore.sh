
#!/bin/sh

. /etc/profile

pg_restore -d vpn vpn.all.2017-01-12-1041.dump

