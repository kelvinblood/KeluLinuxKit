
#!/bin/sh

. /etc/profile

REMOTEURL="http://wechat.kelu.org/api/pptp"
ifconfig=`ifconfig`;
type='heartbeat';
client='tokyo';

REMOTE_CONTENT="type=$type&client=$client&ifconfig=$ifconfig";
REMOTERESULT=`curl -d "$REMOTE_CONTENT" $REMOTEURL`;
