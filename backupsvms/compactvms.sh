#!/bin/sh

LOG_FILE=/var/log/vms/vm-auto-snapshots`date +"%Y-%m-%d"`.log

echo -e `date +"%Y-%m-%d-%T"`" --- Compacting virtualbox vdi images" >> $LOG_FILE
logger "Compactando imagens virtualbox vdi"

VBoxManage list hdds | grep "^UUID:" | awk -F " " '{print $2}' | xargs -L1 VBoxManage modifyhd --compact

echo -e `date +"%Y-%m-%d-%T"`" --- Finalizada a compactação das imagens virtualbox vdi images" >> $LOG_FILE
logger "Finalizada a compactação das imagens virtualbox vdi images"