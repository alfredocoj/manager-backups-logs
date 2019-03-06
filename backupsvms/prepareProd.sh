#!/bin/bash

DIR_VMS_BACKUPS=/var/vmbackup
DIR_VMS_SNAPSHOTS=/var/vmssnapshots

#cp -R ~/IdeaProjects/backups-vms/backupsvms/* /home/$(whoami)/scripts/

#criar usuário linux
$ sudo useradd -m server
#Crie a senha:
$ sudo passwd server
#Adicione o usuário ao grupo sudo:
$ sudo usermod -a -G sudo server
#Altere o shell do usuário:
$ sudo chsh -s /bin/bash server
#Adicionar usuário ao grupo root
sudo usermod -aG root server

sudo chown -R $(whoami):syslog /var/log/vms

sudo mkdir -p $DIR_VMS_BACKUPS
sudo mkdir -p $DIR_VMS_SNAPSHOTS

sudo chown -R $(whoami):$(whoami) $DIR_VMS_BACKUPS
sudo chown -R $(whoami):$(whoami) $DIR_VMS_SNAPSHOTS