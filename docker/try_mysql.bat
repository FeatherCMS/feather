@echo off

REM Base Path (Shared with containers)
set BASE_PATH=C:%homepath%\docker-feather-data\mysql


REM Feather App
set APP_NAME=feather-app-mariadb
set SQL_NAME=feather-db-mariadb  

REM MySQL Root Password
set MYSQLPORT=3306
set MYSQLROOTPW=rootfeather

REM MySQL Feather App db details
set MYSQLFEATHERTABLE=feather
set MYSQLFEATHERUSER=feather
set MYSQLFEATHERPW=feather


REM MariaDB SQL
REM We will use this network for our app, so opening port 8080 here
docker stop %SQL_NAME%
docker rm %SQL_NAME%
docker run -d --name=%SQL_NAME% -p %MYSQLPORT%:3306 -p 8081:8081 -v %BASE_PATH%\mysql\datadir:/var/lib/mysql -v %BASE_PATH%\mysql\log:/var/log/mysql -e MYSQL_ROOT_PASSWORD=%MYSQLROOTPW% -e MYSQL_ROOT_HOST=%% --restart=unless-stopped mariadb:latest

REM Sleep to give time for the DB to start
echo Waiting 30 secs, to give time for the DB to start...
timeout 30

REM Create DB, user
echo CREATE DATABASE %MYSQLFEATHERTABLE%; > feathermysql.sql
echo CREATE USER '%MYSQLFEATHERUSER%'@'%%' IDENTIFIED BY '%MYSQLFEATHERPW%'; >> feathermysql.sql
echo GRANT ALL ON `%MYSQLFEATHERTABLE%`.* TO '%MYSQLFEATHERUSER%'@'%%'; >> feathermysql.sql
echo SELECT host, user FROM mysql.user; >> feathermysql.sql

docker exec -i %SQL_NAME% mysql -uroot -p%MYSQLROOTPW% < feathermysql.sql
del feathermysql.sql


REM Start Feather App
docker stop %APP_NAME%
docker rm %APP_NAME%
docker run -d --name %APP_NAME% --restart=unless-stopped --net=container:%SQL_NAME% -v %BASE_PATH%:/var/feather -e BASE_URL="http://localhost:8081" -e BASE_PORT=8081 -e DBTYPE=mysql -e SQL_HOST=127.0.0.1 -e SQL_PORT=3306 -e SQL_DATABASE=%MYSQLFEATHERTABLE% -e SQL_USER=%MYSQLFEATHERUSER% -e SQL_PASSWORD=%MYSQLFEATHERPW% -e MAX_BODYSIZE="10mb" -d feather

echo You can connect to: 
echo  http://127.0.0.1:8081
timeout 10

