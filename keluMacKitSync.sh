#!/bin/bash
set -e

KELUMACKIT="$HOME/Workspace/KeluMacKit"
RESOURCE="$KELUMACKIT/Resource"
DOWNLOAD="$KELUMACKIT/Download"

cd $HOME
cp .bashrc .inputrc $RESOURCE

cp .tmux.conf.local .vimrc.bundles.local .vimrc.bundles.local $RESOURCE/maximum-awesome

cd $DOWNLOAD/maximum-awesome
cp tmux.conf vimrc vimrc.bundles $RESOURCE/maximum-awesome

cp $DOWNLOAD/tmux-powerline/themes/default.sh $RESOURCE/tmux-powerline/default.sh

echo 'Sync done!'
