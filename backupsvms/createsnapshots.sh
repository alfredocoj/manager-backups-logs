#!/bin/bash

# =============== Definicao de variaveis ===============
LOG_FILE=/var/log/vms/vm-auto-snapshots`date +"%Y-%m-%d"`.log
DIR_SNAPSHOT_BASE=/var/vmssnapshots/
DIR_VIRTUAL_BOX=/home/$(whoami)/VirtualBox\ VMs
names_vms=`VBoxManage list runningvms | sed "s/\"\(.*\)\".*/\1/"`
# ======================================================

for vm in $names_vms
do

    now=`date +"%Y-%m-%d-%T"`

    snapshotname=$vm"_"$now

    snapshotdescricao="Snapshot $vm taken on $now"

    echo -e `date +"%Y-%m-%d-%T"`" --- Criando snapshots from $vm - as $now" >> $LOG_FILE

    VBoxManage snapshot "$vm" take "$snapshotname" --description "$snapshotdescricao" --live

    logger "Finalizada a cricao de snapshot of $vm"

	echo -e `date +"%Y-%m-%d-%T"`" --- Finalizada a cricao de snapshot of $vm" >> $LOG_FILE

	printf "\n\n"
done

if [ -n "$LOG_FILE" ]; then
    exec > >(tee -i -a $LOG_FILE)
    exec 2>&1
fi


for vm in $names_vms
do

mkdir -p $DIR_SNAPSHOT_BASE/$vm

rsync -r $DIR_VIRTUAL_BOX/$vm/Snapshots/*.vdi $DIR_SNAPSHOT_BASE/$vm/
done