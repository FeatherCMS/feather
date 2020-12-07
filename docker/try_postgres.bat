@echo off

REM Base Path (Shared with containers)
set BASE_PATH=C:%homepath%\docker-feather-data\postgres

REM Feather App
set APP_NAME=feather-app-postgres
set SQL_NAME=feather-db-postgres  

REM  postgres Root Password
set POSTGRESPORT=5432
set POSTGRES_ROOTPW=postgres
set POSTGRES_USER=feather
set POSTGRES_PASSWORD=feather
set POSTGRES_DB=feather

REM  MariaDB SQL
REM  We will use this network for our app, so opening port 8080 here
docker stop %SQL_NAME%
docker rm %SQL_NAME%
docker run -d --name=%SQL_NAME% --restart=unless-stopped -p %POSTGRESPORT%:5432 -p 8082:8082 -v %BASE_PATH%\postgresql\data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=%POSTGRES_ROOTPW% -d postgres

REM Sleep to give time for the DB to start
echo "Waiting 30 secs, to give time for the DB to start..."
timeout 30

REM  Create DB, user
echo CREATE DATABASE %POSTGRES_DB%; > featherpostgres.sql
echo CREATE USER %POSTGRES_DB% WITH PASSWORD '%POSTGRES_DB%'; >> featherpostgres.sql
echo GRANT ALL PRIVILEGES ON DATABASE %POSTGRES_DB% TO %POSTGRES_DB%; >> featherpostgres.sql

docker exec -i %SQL_NAME% psql -U postgres < featherpostgres.sql
del featherpostgres.sql


REM Start Feather App
docker stop %APP_NAME%
docker rm %APP_NAME%
docker run -d --name %APP_NAME% --restart=unless-stopped --net=container:%SQL_NAME% -v %BASE_PATH%:/var/feather -e BASE_URL="http://localhost:8082" -e BASE_PORT=8082 -e DBTYPE=postgres -e SQL_HOST=127.0.0.1 -e SQL_PORT=5432 -e SQL_DATABASE=%POSTGRES_DB% -e SQL_USER=%POSTGRES_USER% -e SQL_PASSWORD=%POSTGRES_PASSWORD% -e MAX_BODYSIZE="10mb" -d feather

echo You can connect to: 
echo  http://127.0.0.1:8082
timeout 10
