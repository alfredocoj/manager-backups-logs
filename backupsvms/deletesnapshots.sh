#!/bin/sh


LOG_FILE=/var/log/vms/vm-auto-snapshots`date +"%Y-%m-%d"`.log
DIR_SNAPSHOT_BASE=/var/vmssnapshots/
DIR_VIRTUAL_BOX=/home/$(whoami)/VirtualBox\ VMs

# Deletes old snapshots
usage ()
{
  echo "usage: $0 [number of snapshots to keep]"
  exit
}

[ -n "$1" ] || usage

names_vms=`VBoxManage list runningvms | sed "s/\"\(.*\)\".*/\1/"`

for vm in $names_vms
do

	echo -e `date +"%Y-%m-%d-%T"`" --- Deletando todas os snapshots menos os $1 snapshots mais recentes from $vm" >> $LOG_FILE

	## convertendo ...
	numsnapshots=$(($1*3))

	VBoxManage snapshot "$vm" list | awk -F "UUID: " '{print $2}' | awk -F ")" '{print $1}' | head -n -"$numsnapshots" | xargs -L1 VBoxManage snapshot "$vm" delete

	logger "Finished snapshot deletion of $vm"

	echo -e `date +"%Y-%m-%d-%T"`" --- Finalizado o delete de snapshots de $vm" >> $LOG_FILE

	printf "\n\n"
done

for vm in $names_vms
do
rsync -R $DIR_VIRTUAL_BOX/$vm/Snapshots/*.vdi $DIR_SNAPSHOT_BASE/$vm/
done

## 6 ---> 2
## x ---> 5
## x = 15