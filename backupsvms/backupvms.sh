#!/bin/bash

# Esse script percorre todas as vm's do VirtualBox do usuário, fazem uma pausa,
# exporta-os e restaura o estado original.
#
# O sistema de snapshot do VirtualBox não é estável o suficiente para uso não monitorado ainda.
#

# =============== Definicao de variaveis ===============

  EXPORTDIR=/var/vmbackup
  MYMAIL=alfredo.coj@gmail.com
  VBOXMANAGE="/usr/bin/VBoxManage -q"
  LOG_FILE=/var/log/vms/backup_vms_`date +"%Y-%m-%d"`.log

# =======================================================

# Gera uma lista de todas as vm's; usa sed para remover as aspas duplas.

for VMNAME in $(vboxmanage list vms | cut -d " " -f 1 | sed -e 's/^"//'  -e 's/"$//')
do

  ERR="nothing"
  SECONDS=0

  # Obtem o estado da VM
    VMSTATE=$(vboxmanage showvminfo $VMNAME --machinereadable | grep "VMState=" | cut -f 2 -d "=")
    echo -e `date +"%Y-%m-%d-%T"`" --- $VMNAME's tem estado: $VMSTATE." >> $LOG_FILE

  # Se o estado da VM estiver em execução ou em pausa, salve seu estado
    if [[ $VMSTATE == \"running\" || $VMSTATE == \"paused\" ]]; then
      echo -e `date +"%Y-%m-%d-%T"`" --- Salvando estado..." >> $LOG_FILE
      vboxmanage controlvm $VMNAME savestate
      if [ $? -ne 0 ]; then ERR="salvando estado"; fi
    fi

  # Exporta a vm como appliance
    if [ "$ERR" == "nothing" ]; then
      echo -e `date +"%Y-%m-%d-%T"`" --- Exportando a VM $VMNAME..." >> $LOG_FILE
      vboxmanage export $VMNAME --output $EXPORTDIR/$VMNAME-new.ova &> $LOG_FILE
      if [ $? -ne 0 ]; then
        ERR="exporting"
      else
        # Remove o backup antigo e o renomeia novamente
       if [ -e $EXPORTDIR/$VMNAME.ova ]; then rm $EXPORTDIR/$VMNAME.ova; fi
       mv $EXPORTDIR/$VMNAME-new.ova $EXPORTDIR/$VMNAME.ova
       # Obter tamanho do arquivo
       FILESIZE=$(du -h $EXPORTDIR/$VMNAME.ova | cut -f 1)
      fi
    else
      echo -e `date +"%Y-%m-%d-%T"`" --- Não foi possível exportar, porque o estado da VM $VMNAME não permite ser salva." >> $LOG_FILE
    fi

  # Retomar a VM para seu estado anterior, se esse estado foi pausado ou em execução
    if [[ $VMSTATE == \"running\" || $VMSTATE == \"paused\" ]]; then
        echo -e `date +"%Y-%m-%d-%T"`" --- VM - $VMNAME - resumo do estado anterior..." >> $LOG_FILE
        vboxmanage startvm $VMNAME --type headless
        if [ $? -ne 0 ]; then ERR="resuming"; fi
        if [ $VMSTATE == \"paused\" ]; then
          vboxmanage controlvm $VMNAME pause
          if [ $? -ne 0 ]; then ERR="pausing"; fi
        fi
      fi

  # Calcula a duração
    duration=$SECONDS
    duration="Operação levou $(($duration / 60)) minutos, $(($duration % 60)) segundos."
    echo -e "$duration" >> $LOG_FILE

## Notifica o administrador via e-mail
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