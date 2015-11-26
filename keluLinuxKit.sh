#!/bin/bash

apt-get -y install unzip
wget https://github.com/kelvinblood/KeluLinuxKit/archive/master.zip
unzip master.zip
mv KeluLinuxKit-master/ KeluLinuxKit
rm master.zip
