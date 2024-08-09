# Wordpress

## Procedimentos:

Criar o arquivo `.env` baseado no `.env.example`

Criar e preencher os arquivos:
```
conf/mysql/secrets/MYSQL_DATABASE
conf/mysql/secrets/MYSQL_PASSWORD
conf/mysql/secrets/MYSQL_ROOT_PASSWORD
conf/mysql/secrets/MYSQL_USER
```

Criar os diretórios de volumes:
```
mkdir -p volumes/backups/database/
mkdir -p volumes/backups/wordpress/
mkdir -p volumes/log/mysql/
mkdir -p volumes/log/nginx/
mkdir -p volumes/wordpress/
```

Uso do script para gerenciar o projeto
```
./script.sh start
./script.sh stop
./script.sh reload
./script.sh restart
./script.sh ps
./script.sh logs
./script.sh build
./script.sh pull
./script.sh backup
```

## Dependências

Este projeto foi desenvolvido para infraestrutura em Docker Swarm (Cluster Docker). Para isso basta em caso de ambiente novo, por exemplo, iniciar o Cluster. Comando:

`docker swarm init`

Outra dependência seria o Traefik, em que o serviço Web com Nginx popula as suas informações de acesso. Caso a rede traefik não exista, basta criar. Exemplo:

`docker network create --driver overlay --attachable=true traefik`
