
### Configurando backup usando rsnapshot linux

Um tutorial muito bom pode ser encontrado nesse [link](https://www.ostechnix.com/setup-backup-server-using-rsnapshot-linux/).

#### Préquisitos
 
Crie um usuário com permissão de root.

```
#criar usuário linux
$ sudo useradd -m server 
#Crie a senha: 
$ sudo passwd server 
#Adicione o usuário ao grupo sudo: 
$ usermod -a -G sudo server 
#Altere o shell do usuário: 
$ sudo chsh -s /bin/bash server 
#Adicionar usuário ao grupo root
sudo usermod -aG root server 

# confirmar os grupos que usuário logado está no grupo:
$ id -nG
```
Próximo passo, copie sua chave ssh pública para os clientes remotos.

```
$ ssh-copy-id -i /root/.ssh/id_rsa.pub server@192.168.6.151
```

#### Passo a passo
Defina um local para o diretório padrão de backup.

```
sudo mkdir /rsnapbackup/
```

Por garantia antes de iniciar as configurações, faça um backup do arquivo de configuração do rsnapshot.

```
cp /etc/rsnapshot.conf /etc/rsnapshot.conf.bak
```

Em seguida, edite o arquivo de configuração:
```
sudo nano /etc/rsnapshot.conf
```

A configuração padrão deve funcionar bem. Tudo o que você precisa para definir os diretórios de backup e os intervalos de backup.

Primeiro, vamos configurar o diretório de backup raiz, ou seja, precisamos escolher o diretório onde queremos armazenar os backups do sistema de arquivos. Em nosso caso, armazenarei as cópias de segurança no diretório `/rsnapbackup/`.

```
# All snapshots will be stored under this root directory.
#
snapshot_root   /rsnapbackup/

```

Novamente, você deve usar a tecla TAB entre o elemento snapshot_root e seu diretório de backup.

Role um pouco para baixo e verifique se as seguintes linhas (marcadas em negrito) não estão comentadas:

```
[...]
#################################
# EXTERNAL PROGRAM DEPENDENCIES #
#################################

# LINUX USERS: Be sure to uncomment "cmd_cp". This gives you extra features.
# EVERYONE ELSE: Leave "cmd_cp" commented out for compatibility.
#
# See the README file or the man page for more details.
#
cmd_cp /usr/bin/cp

# uncomment this to use the rm program instead of the built-in perl routine.
#
cmd_rm /usr/bin/rm

# rsync must be enabled for anything to work. This is the only command that
# must be enabled.
#
cmd_rsync /usr/bin/rsync

# Uncomment this to enable remote ssh backups over rsync.
#
cmd_ssh /usr/bin/ssh

# Comment this out to disable syslog support.
#
cmd_logger /usr/bin/logger

# Uncomment this to specify the path to "du" for disk usage checks.
# If you have an older version of "du", you may also want to check the
# "du_args" parameter below.
#
cmd_du /usr/bin/du

[...]
```

Em seguida, precisamos definir os intervalos de backup:

```
#########################################
# BACKUP LEVELS / INTERVALS #
# Must be unique and in ascending order #
# e.g. alpha, beta, gamma, etc. #
#########################################

retain alpha 6
retain beta 7
retain gamma 4
#retain delta 3
```

Em seguida, precisamos definir os diretórios de backup. Encontre as seguintes diretivas no seu arquivo de configuração do rsnapshot e defina as localizações do diretório de backup.

```
###############################
### BACKUP POINTS / SCRIPTS ###
###############################

# LOCALHOST
backup /root/ostechnix/ server/
```

Aqui, vou fazer o backup do conteúdo do diretório `/root/ostechnix/` e salvá-los no diretório `/rsnapbackup/server/`. Por favor, note que eu não especifiquei o caminho completo (`/rsnapbackup/server/`) na configuração acima. Porque já mencionamos o diretório de backup raiz anteriormente.

Da mesma forma, defina o local de backup de seus sistemas de clientes remotos.

```
# REMOTEHOST
backup alfredo@192.168.6.151:/var/vmbackup/ client/server151vmbackups/

backup alfredo@192.168.6.151:/var/vmsnapshots/ client/server151vmssnapshots/
```

Aqui, vou fazer o backup do conteúdo dos diretórios remotos `/var/vmbackup/` e `/var/vmsnapshots/` do meu sistema cliente e salvá-los nos diretórios `client/server151vmbackups/` e `client/server151vmssnapshots/` em meu servidor de backup. Mais uma vez, observe que eu não especifiquei o caminho completo (`/rsnapbackup/client/`) na configuração acima. Porque já mencionamos o diretório de backup raiz antes.

Salve e feche o arquivo `/ect/rsnapshot.conf`.

Depois de ter feito todas as alterações, execute o seguinte comando para verificar se o arquivo de configuração é sintaticamente válido.

```
$ rsnapshot configtest
```

Se tudo estiver bem, você verá a seguinte saída.

```
Syntax OK
```

Obs.: Utilize sempre tabs ao invés de espaços no arquivo de configuração `/etc/rsnapshot.conf`.


#### Testando o backup

Execute um dos níveis e modelos de backup da seção `BACKUP LEVELS / INTERVALS #` do arquivo `/etc/rsnapshot.conf`.

Para teste, execute:

```
# rsnapshot alpha
```

Cheque os diretórios:

```
$ ls /rsnapbackup/alpha.0/client
```

#### Automatizando backups

Defina um cron job e automatize o trabalho de backup.

```
sudo nano /etc/cron.d/rsnapshot
```

Adicione as seguintes linhas se não tiverem já sido adicionadas ou altere para as configurações de preferência:

```
0 */4 * * *     /usr/bin/rsnapshot alpha
50 23 * * *     /usr/bin/rsnapshot beta
00 22 1 * *     /usr/bin/rsnapshot delta
```

A primeira linha indica que serão feitos seis instantâneos alfa por dia (0,4,8,12,16 e 20 horas), instantâneos beta tirados todas as noites às 23h50 e fotos delta serão tiradas às 10h da noite. o primeiro dia de cada mês. Você pode ajustar o tempo conforme o seu desejo. Salve e feche o arquivo.

Feito! O Rsnapshot fará automaticamente backups no horário definido no cron job.


### Referências

[Fonte 1](https://blog.sleeplessbeastie.eu/2013/07/23/virtualbox-how-to-control-virtual-machine-using-command-line/)

[Fonte 2](https://github.com/chase-miller/virtualbox-snapshot-create/blob/master/snapshot-virtualbox.sh)

[Fonte 3](https://gist.github.com/mgeeky/f95faffa45e28f214f9c4821f96cd972)

[Fonte 4](https://vorkbaard.nl/backup-script-for-virtualbox-vms-in-debian/)

[Fonte 5](https://gist.github.com/betweenbrain/dc372b03375023afc125)

[Fonte 6](https://github.com/sqeeek/virtualbox-backup-script)

[Fonte 7](https://gist.github.com/betweenbrain/dc372b03375023afc125)