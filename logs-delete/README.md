### Limpeza automática de Logs do Docker

#### Compressão automática de logs do docker 
Para configurar será necessário criar o arquivo abaixo:

```
$ cat /etc/logrotate.d/docker-container

    /var/lib/docker/containers/*/*.log {
      rotate 7
      daily
      compress
      size=1M
      missingok
      delaycompress
      copytruncate
    }
```

Uma vez que o arquivo foi criado, basta testar a rotação com o comando abaixo.
```
logrotate -fv /etc/logrotate.d/docker-container
```
Pronto rotação configurada, você verá um novo arquivo compactado (.gz) a cada rotação, agora é só deixar o logrotate fazer o trabalho.


#### Limpeza manual
Também é possível executar a limpeza na força bruta, onde todos os logs serão apagados com o comando abaixo:

Atenção! Todos os logs.

truncate -s 0 /var/lib/docker/containers/*/*-json.log


#### Referências:
[Fonte 1](https://www.coisadeprogramador.com.br/limpeza-organizacao-logs-docker-container/)

[Fonte 2](https://sandro-keil.de/blog/logrotate-for-docker-container/)
