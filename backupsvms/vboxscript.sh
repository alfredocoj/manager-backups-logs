#!/bin/bash
​

vmmastername=vmmaster
vmnode96name=vmdockerqt
vmnode97name=vmdockerjava


########################################################################################################################

## SNAPSHOT DA VM_MASTER: 6.95

vmmastername=debian
now=`date +"%Y-%m-%d-%T"`
snapshotname=$vmmastername"_"$now
​snapshotdescricao="Snapshot $vmmastername taken on $now"

VBoxManage snapshot "$vmmastername" take "$snapshotname" --description "$snapshotdescricao"
########################################################################################################################

## SNAPSHOT DA VM_NODE96

now=`date +"%Y-%m-%d-%T"`
​snapshotname=$vmnode96name"_"$now
​snapshotdescricao="Snapshot $vmnode96name taken on $now"

VBoxManage snapshot "$vmnode96name" take "$snapshotname" --description "$snapshotdescricao"

########################################################################################################################

## SNAPSHOT DA VM_NODE97

now=`date +"%Y-%m-%d-%T"`
​snapshotname=$vmnode97name"_"$now
​snapshotdescricao="Snapshot $vmnode97name taken on $now"

VBoxManage snapshot "$vmnode97name" take "$snapshotname" --description "$snapshotdescricao"




rsync /root/VirtualBox\ VMs/$vmmastername/Snapshots