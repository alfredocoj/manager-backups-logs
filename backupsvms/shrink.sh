#!/bin/bash

# Remove unused dependencies
sudo apt-get autoremove -y

# Remove APT cache
sudo apt-get clean -y
sudo apt-get autoclean -y

# Remove APT files
find /var/lib/apt -type f | xargs rm -f

# Remove Linux headers
sudo rm -rf /usr/src/linux-headers*

# Cleanup log files
sudo find /var/log -type f | while read f; do echo -ne '' > $f; done;

logrotate -fv /etc/logrotate.d/docker-logs

sudo apt-get update

sudo apt-get install zerofree

mkdir /mnt/tmp
mount -o ro /dev/sda1 /mnt/tmp
zerofree /dev/sda1

# Clear bash history
# history -c


# Baseado em:
#  - http://vstone.eu/reducing-vagrant-box-size/
#  - https://github.com/mitchellh/vagrant/issues/343
#  - https://gist.github.com/adrienbrault/3775253