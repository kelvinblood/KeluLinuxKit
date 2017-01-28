
#!/bin/sh

. /etc/profile

REMOTEURL="$MASTER_API/pptp"
ifconfig=`ifconfig`;
type='heartbeat';
client='$CLIENT_NAME';

REMOTE_CONTENT="type=$type&client=$client&ifconfig=$ifconfig";
REMOTERESULT=`curl -d "$REMOTE_CONTENT" $REMOTEURL`;
