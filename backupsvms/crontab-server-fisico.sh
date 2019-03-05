#!/bin/bash

#crontab -e: editar o arquivo atual ou criar um, caso não exista
#crontab -l: listar suas tarefas programadas
#crontab -r: remover uma tarefa programada
# ver logs do crontab: $ grep CRON /var/log/syslog

## executa todos os dias às 0h30
35 11 * * * /home/alfredo/scripts/compactvms.sh
## executa todos os dias às 1h
37 11 * * * /home/alfredo/scripts/backupvms.sh
## executa todos os domingo às 3h
30 11 * * * /home/alfredo/scripts/deletesnapshots.sh 3
## executa a cada 2h de cada dia
27 11 * * * /home/alfredo/scripts/createsnapshots.sh