#!/bin/bash

apt-get update
apt-get install -y unzip

cd /var/local
wget https://github.com/kelvinblood/KeluLinuxKit/archive/master.zip
unzip master.zip
mv KeluLinuxKit-master/ KeluLinuxKit

echo "Linode should change the kernel, then run the script!"