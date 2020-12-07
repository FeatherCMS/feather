# #!/bin/bash

## Base Path (Shared with containers)
export BASE_PATH=$PWD/docker-feather-data/postgres

## Feather App
export APP_NAME=feather-app-postgres
export SQL_NAME=feather-db-postgres  

### postgres Root Password
export POSTGRESPORT=5432
export POSTGRES_ROOTPW=postgres
export POSTGRES_USER=feather
export POSTGRES_PASSWORD=feather
export POSTGRES_DB=feather

### MariaDB SQL
### We will use this network for our app, so opening port 8080 here
docker stop $SQL_NAME
docker rm $SQL_NAME
docker run -d --name=$SQL_NAME \
    --restart=unless-stopped \
    -p $POSTGRESPORT:5432 \
    -p 8082:8082 \
    -v $BASE_PATH/postgresql/data:/var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=$POSTGRES_ROOTPW \
    -d postgres

## Sleep to give time for the DB to start
echo "Waiting 30 secs, to give time for the DB to start..."
sleep 30

### Create DB, user
echo "CREATE DATABASE ${POSTGRES_DB}; \
CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}'; \
GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_USER};" \
> featherpostgres.sql
docker exec -i $SQL_NAME psql -U postgres < featherpostgres.sql && true
rm featherpostgres.sql


## Start Feather App
docker stop $APP_NAME
docker rm $APP_NAME
docker run -d --name $APP_NAME \
    --restart=unless-stopped \
    --net=container:$SQL_NAME \
    -v $BASE_PATH:/var/feather \
    -e BASE_URL="http://localhost:8082" \
    -e BASE_PORT=8082 \
    -e DBTYPE=postgres \
    -e SQL_HOST=127.0.0.1 \
    -e SQL_PORT=5432 \
    -e SQL_DATABASE=$POSTGRES_DB \
    -e SQL_USER=$POSTGRES_USER \
    -e SQL_PASSWORD=$POSTGRES_PASSWORD \
    -e MAX_BODYSIZE="10mb" \
    -d feather

echo "You can connect to: "
echo " http://127.0.0.1:8082"
echo ""
sleep 10
