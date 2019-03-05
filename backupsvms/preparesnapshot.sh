#!/bin/bash

DIR_VMS_BACKUPS=/var/vmbackup
DIR_VMS_SNAPSHOTS=/var/vmssnapshots

cp -R ~/IdeaProjects/backups-vms/backupsvms/* /home/$(whoami)/scripts/
#scp -R alfredo@10.121.2.49:/home/alfredo/IdeaProjects/backups-vms/backupsvms/* /home/$(whoami)/scripts/

sudo chown -R $(whoami):syslog /var/log/vms

sudo mkdir -p $DIR_VMS_BACKUPS
sudo mkdir -p $DIR_VMS_SNAPSHOTS

sudo chown -R $(whoami):$(whoami) $DIR_VMS_BACKUPS
sudo chown -R $(whoami):$(whoami) $DIR_VMS_SNAPSHOTS