# #!/bin/bash

## Base Path (Shared with containers)
export BASE_PATH=$PWD/docker-feather-data/mysql

## Feather App
export APP_NAME=feather-app-mariadb
export SQL_NAME=feather-db-mariadb  

### MySQL Root Password
export MYSQLPORT=3306
export MYSQLROOTPW=rootfeather

### MySQL Feather App db details
export MYSQLFEATHERTABLE=feather
export MYSQLFEATHERUSER=feather
export MYSQLFEATHERPW=feather


### MariaDB SQL (You can use mysql if you want)
### We will use this network for our app, so opening port 8081 here
docker stop $SQL_NAME
docker rm $SQL_NAME
docker run -d --name=$SQL_NAME \
    -p $MYSQLPORT:3306 \
    -p 8081:8081 \
    -v $BASE_PATH/mysql/datadir:/var/lib/mysql \
    -v $BASE_PATH/mysql/log:/var/log/mysql \
    -e MYSQL_ROOT_PASSWORD=$MYSQLROOTPW \
    -e MYSQL_ROOT_HOST=% \
    --restart=unless-stopped \
    mariadb:latest \
    --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

## Sleep to give time for the DB to start
echo "Waiting 30 secs, to give time for the DB to start..."
sleep 30

### Create DB, user
echo "CREATE DATABASE ${MYSQLFEATHERTABLE}; \
CREATE USER '${MYSQLFEATHERUSER}'@'%' IDENTIFIED BY '${MYSQLFEATHERPW}'; \
grant all on \`${MYSQLFEATHERTABLE}\`.* to '${MYSQLFEATHERUSER}'@'%'; \
SELECT host, user FROM mysql.user;" \
> feathermysql.sql
docker exec -i $SQL_NAME mysql -uroot -p$MYSQLROOTPW < feathermysql.sql && true
rm feathermysql.sql


## Start Feather App
docker stop $APP_NAME
docker rm $APP_NAME
docker run -d --name $APP_NAME \
    --restart=unless-stopped \
    --net=container:$SQL_NAME \
    -v $BASE_PATH:/var/feather \
    -e BASE_URL="http://localhost:8081" \
    -e BASE_PORT=8081 \
    -e DBTYPE=mysql \
    -e SQL_HOST=127.0.0.1 \
    -e SQL_PORT=3306 \
    -e SQL_DATABASE=$MYSQLFEATHERTABLE \
    -e SQL_USER=$MYSQLFEATHERUSER \
    -e SQL_PASSWORD=$MYSQLFEATHERPW \
    -e MAX_BODYSIZE="10mb" \
    -d feather

echo "You can connect to: "
echo " http://127.0.0.1:8081"
echo ""
sleep 10
