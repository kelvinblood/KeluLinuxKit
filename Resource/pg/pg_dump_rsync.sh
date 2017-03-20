
#!/bin/sh

. /etc/profile

rsync -a --delete -e "ssh -p 22000 -i /home/runner/.ssh/pg_dump.pri" pg_dump@zp2.com:/var/local/pg_dump/* /var/local/pg_dump/
