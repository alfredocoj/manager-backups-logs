#!/bin/bash
#rvms are running, nrvms are not
VMS="$(VBoxManage list vms | sed -e 's/.*{\([^}]\+\)}.*/\1/g')"
RVMS="$(VBoxManage list runningvms | sed -e 's/.*{\([^}]\+\)}.*/\1/g')"
NRVMS="$(echo $VMS | sed "s/\b$RVMS\b//g")"
#set to actual path if you want actual path in here - format is /this/is/a/path/
BKPATH=$1
LOGFILE=~/vm-backup.log
DATESTMP="$(date +'%Y-%m-%d_%H-%M-%S')"

for RVM in $RVMS
do
        name="$(VBoxManage list vms | grep $RVM | sed -e 's/{[^{}]*}//g' | sed 's/\"//g' | tr -d '[[:space:]]')"
        VBoxManage controlvm $RVM savestate
        VBoxManage export $RVM -o $BKPATH$(hostname)-$DATESTMP-$name.ova
        VBoxManage startvm --type headless $RVM

done

for NRVM in $NRVMS
do
        name="$(VBoxManage list vms | grep $NRVM | sed -e 's/{[^{}]*}//g' | sed 's/\"//g' | tr -d '[[:space:]]')"
        VBoxManage export $NRVM -o $BKPATH$(hostname)-$DATESTMP-$name.ova
done

echo $DATESTMP >> $LOGFILE
