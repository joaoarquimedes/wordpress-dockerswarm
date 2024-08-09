#!/bin/bash

export PATH_FULL=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $PATH_FULL

export $(cat .env)

function start() {
  docker stack deploy --compose-file docker-compose.yml ${STACK} --detach=true
  sleep 5
  docker container prune -f
}

function stop() {
  docker stack rm ${STACK}
}

function reload() {
  docker service update --force ${STACK}_wordpress ${STACK}_nginx
}

function restart(){
  stop
  echo -n "Restarting."
  while ps | grep "Running" > /dev/null 2> /dev/null
  do
   echo -n "."
   sleep 2
  done
  start
}

function ps(){
  docker stack ps ${STACK}
}

function build() {
  docker pull nginx:${NGINX_VERSION}
  docker compose build nginx
}

function pull() {
  docker pull nginx:${NGINX_VERSION}
  docker pull wordpress:${WORDPRESS_VERSION}
  docker pull mysql:${MYSQL_VERSION}
  docker pull sftp
}

function backup(){
  docker run --rm \
  --name ${STACK}-backup \
  --network ${STACK} \
  --env-file .env \
  --volume ./conf/mysql/secrets:/secrets \
  --volume ./volumes/backups/database/:/var/backups/database \
  mysql:${MYSQL_VERSION} bash -c '\
    mysqldump \
    --user=root \
    --password=$(cat /secrets/MYSQL_ROOT_PASSWORD) \
    --host=${STACK}_database $(cat /secrets/MYSQL_DATABASE) | gzip -f > /var/backups/database/$(cat /secrets/MYSQL_DATABASE)-$(date +"%A").sql.gz'
}

$1
