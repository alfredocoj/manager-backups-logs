#### Scripts de Backup e Snapshot de VMs

Descrição dos principais scripts:

 - `compactvms.sh`: script que compacta às VMs antes do backup, diariamente às 0h00.
 - `backupvms.sh`: script que realiza um export das VMS diariamente às 1h00.
 - `createsnapshots.sh`: script para a criacão das snapshots das VMs que estão em execução diariamente a cada 2h.
 - `deletesnapshots.sh`: script para a remoção das snapshots das VMs que estão em execução todo domingo às 3h, deixando apenas os últimos 7 snapshots.
 - `shrink.sh`: script que deve ser executado em cada VM em uma rotina semanal, a cada 7 dias às 23h, para ser executada via puppet.

Os modelos de configuração de `crontab` estão descritos nos arquivos: `crontab-server-fisico` e `crontab-vms`.

Os scripts auxiliares são descritos em:

- `scpScriptsAndPrepareProd`: script para subir os scripts de producao para o(s) servidore(s) físico(s) e que chama o script de preparação do ambiente de produção `prepareProd.sh`.
- `prepareProd.sh`: cria e configura as permissões nos diretórios de log e backups.
- `scpShrinkVMs`: script para subir o script de shrink para as VMs.


#### Referências

[Fonte 1](https://blog.sleeplessbeastie.eu/2013/07/23/virtualbox-how-to-control-virtual-machine-using-command-line/)

[Fonte 2](https://github.com/chase-miller/virtualbox-snapshot-create/blob/master/snapshot-virtualbox.sh)

[Fonte 3](https://gist.github.com/mgeeky/f95faffa45e28f214f9c4821f96cd972)

[Fonte 4](https://vorkbaard.nl/backup-script-for-virtualbox-vms-in-debian/)

[Fonte 5](https://gist.github.com/betweenbrain/dc372b03375023afc125)

[Fonte 6](https://github.com/sqeeek/virtualbox-backup-script)

[Fonte 7](https://gist.github.com/betweenbrain/dc372b03375023afc125)