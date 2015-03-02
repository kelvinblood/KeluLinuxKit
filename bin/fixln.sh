#!/bin/bash

KELULINUXKIT=$(pwd)
TMUXCONF="$KELULINUXKIT/Download/maximum-awesome-linux"

cd $HOME
rm .tmux.conf .vim .vimrc .vimrc.bundles

ln -s $TMUXCONF/tmux.conf $HOME/.tmux.conf
ln -s $TMUXCONF/vim $HOME/.vim
ln -s $TMUXCONF/vimrc $HOME/.vimrc
ln -s $TMUXCONF/vimrc.bundles $HOME/.vimrc.bundles
