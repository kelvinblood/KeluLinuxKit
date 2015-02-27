#!/bin/bash

cd /home/github/kelvinblood.github.com
git pull
git add .
commitNote=$1
if [ "$?" -eq 0 ]; then
    git commit -a -m "auto_commit"
else
    git commit -a -m "$commitNote"
fi
git push;
