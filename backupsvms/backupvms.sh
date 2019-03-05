#!/bin/bash

# This scripts loops through all the user's VirtualBox vm's, pauses them,
# exports them and then restores the original state.
#
# VirtualBox's snapshot system is not stable enough for unmonitored use yet.
#

# =============== Set your variables here ===============

  EXPORTDIR=/var/vmbackup
  MYMAIL=alfredo.coj@gmail.com
  VBOXMANAGE="/usr/bin/VBoxManage -q"
  LOG_FILE=/var/log/vms/backup_vms_`date +"%Y-%m-%d"`.log

# =======================================================

# Generate a list of all vm's; use sed to remove the double quotes.

# Note: better not use quotes or spaces in your vm name. If you do,
# consider using the vms' ids instead of friendly names:
# for VMNAME in $(vboxmanage list vms | cud -t " " -f 2)
# Then you'd get the ids in your mail so you'd have to use vboxmanage
# showvminfo $id or something to retrieve the vm's name. I never use
# weird characters in my vm names anyway.

for VMNAME in $(vboxmanage list vms | cut -d " " -f 1 | sed -e 's/^"//'  -e 's/"$//')
do

  ERR="nothing"
  SECONDS=0

  # Delete old $LOG_FILE file if it exists
    if [ -e $LOG_FILE ]; then rm $LOG_FILE; fi

  # Get the vm state
    VMSTATE=$(vboxmanage showvminfo $VMNAME --machinereadable | grep "VMState=" | cut -f 2 -d "=")
    echo -e `date +"%Y-%m-%d-%T"`" --- $VMNAME's tem estado: $VMSTATE." >> $LOG_FILE

  # If the VM's state is running or paused, save its state
    if [[ $VMSTATE == \"running\" || $VMSTATE == \"paused\" ]]; then
      echo -e `date +"%Y-%m-%d-%T"`" --- Salvando estado..." >> $LOG_FILE
      vboxmanage controlvm $VMNAME savestate
      if [ $? -ne 0 ]; then ERR="salvando estado"; fi
    fi

  # Export the vm as appliance
    if [ "$ERR" == "nothing" ]; then
      echo -e `date +"%Y-%m-%d-%T"`" --- Exportando a VM $VMNAME..." >> $LOG_FILE
      vboxmanage export $VMNAME --output $EXPORTDIR/$VMNAME-new.ova &> $LOG_FILE
      if [ $? -ne 0 ]; then
        ERR="exporting"
      else
        # Remove old backup and rename new one
       if [ -e $EXPORTDIR/$VMNAME.ova ]; then rm $EXPORTDIR/$VMNAME.ova; fi
       mv $EXPORTDIR/$VMNAME-new.ova $EXPORTDIR/$VMNAME.ova
       # Get file size
       FILESIZE=$(du -h $EXPORTDIR/$VMNAME.ova | cut -f 1)
      fi
    else
      echo -e `date +"%Y-%m-%d-%T"`" --- Não foi possível exportar, porque o estado da VM $VMNAME não permite ser salva." >> $LOG_FILE
    fi

  # Resume the VM to its previous state if that state was paused or running
    if [[ $VMSTATE == \"running\" || $VMSTATE == \"paused\" ]]; then
        echo -e `date +"%Y-%m-%d-%T"`" --- VM - $VMNAME - resumo do estado anterior..." >> $LOG_FILE
        vboxmanage startvm $VMNAME --type headless
        if [ $? -ne 0 ]; then ERR="resuming"; fi
        if [ $VMSTATE == \"paused\" ]; then
          vboxmanage controlvm $VMNAME pause
          if [ $? -ne 0 ]; then ERR="pausing"; fi
        fi
      fi

  # Calculate duration
    duration=$SECONDS
    duration="Operação levou $(($duration / 60)) minutos, $(($duration % 60)) segundos."
    echo -e "$duration" >> $LOG_FILE

## Notify the admin
#    if [ "$ERR" == "nothing" ]; then
#      MAILBODY="Virtual Machine $VMNAME was exported succesfully!"
#      MAILBODY="$MAILBODY"$'\n'"$duration"
#      MAILBODY="$MAILBODY"$'\n'"Export filesize: $FILESIZE"
#      MAILSUBJECT="VM $VMNAME succesfully backed up"
#    else
#      MAILBODY="There was an error $ERR VM $VMNAME."
#      if [ "$ERR" == "exporting" ]; then
#        MAILBODY=$(echo $MAILBODY && cat $LOG_FILE)
#      fi
#      MAILSUBJECT="Error exporting VM $VMNAME"
#    fi
#
#  # Send the mail
#    echo "$MAILBODY" | mail -s "$MAILSUBJECT" $MYMAIL
#
#  # Clean up
#    if [ -e $LOG_FILE ]; then rm $LOG_FILE; fi

done

## rsync