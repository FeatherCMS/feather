# Docker + Feather CMS 🪶

- Feather is a modern Swift-based content management system powered by Vapor 4.

- Docker is a set of platform as a service products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels. 

## Requirements 

- Docker installed on your computer. [Get Docker.com](https://docs.docker.com/get-docker/)

- Basic knowledge of [Docker Compose](https://docs.docker.com/compose/)

- Basic knowledge of [Docker](https://docs.docker.com/)


## Installation

- Clone or download the source files

- Start the application using `docker-compose`

## Usage

### Testing the integrated database (sqlite)
the base url of your web server will be http://localhost:8080


```bash
docker-compose up
```

### Testing mysql database
the base url of your web server will be http://localhost:8081
& the database will be accessible on port `3306`. 
- `root password`: root
- `TABLE`: feather - `USER`: feather - `PASS`: feather

```bash
docker-compose -f mysql.yml up
```

### Testing postgres database
`⚠️ There is a pending issue with Postgres. It is unsuable for the moment`

the base url of your web server will be http://localhost:8082
& the database will be accessible on port `5432`. 
- `root password`: postgres
- `TABLE`: feather - `USER`: feather - `PASS`: feather

```bash
docker-compose -f postgres.yml up
```

## Custumazing the docker

You can check the [Dockerfile](https://github.com/FeatherCMS/feather/blob/main/Dockerfile?raw=true) and the different step of the build.

Here is a brief descritpion of the process

1. We use `swift:5.3.1-focal` as our main builder
2. You can have your own `PRIVATE` custom module and cloning over `ssh` is supported:
    -  We need to add the SSH Hostname to `known_host` (This is use for Private repo in SPM)
    In our example `Line 21` -> `ssh-keyscan -H github.com  >> ~/.ssh/known_hosts;`
    -  At the root levele of the repository, create a folder `ssh` and copy your `unencrypted` private key in this folder. The Docker build will picked it up.
    - The private key will not be part of the final build. So you can distribute the image.
4. You can also add some customs scripts/content to be part of the docker. They will be available at the path `/opt/feather` 
    - create a folder `customscripts` at the root lever of the repository
    - add your content to it
    - Please note that a `chmod 550` will be apply to it

3. When the build complete, we will use `swift:5.3.1-focal-slim`  to build the final result. 
    - Using this will drastycally decrease the final size of the docker image
    - User details running the application inside the container:(`uid=999(feather) gid=999(feather) groups=999(feather)`. Please make sure you give read/write to this user

## Available environement variable 

```
BASE_URL="http://localhost:8080"
BASE_PATH="/var/feather"
BASE_PORT=8080

## Default sqlite
DB_TYPE="sqlite"
MAX_BODYSIZE="10mb"
USE_FILE_MIDDLEWARE="true"

## Using mysql/mariadb/postgres
DB_HOST="localhost"
DB_PORT=3306 or 5432 # The port will use the default one, if you use a custom port, set this env variable
DB_USER="feather"
DB_PASS="feather"
```
## Docker Working directory

The default working directory is `/var/feather` you can mount a volume at this path. You may also use a different folder by setting the `BASE_PATH` environment variable.


## Docker entry point

The default entry point is `/opt/feather/start`. You may want to custumize the start behaviour. In that case, add a script `start` to the `customscripts` folder, it will be overwriten durring the build.

### Default provided entry point

This script will check if you had previously prepared data and put then in the define `BASE_PATH`. It will then start `Feather`

```
#!/bin/bash

[[ ! -d \"\${BASE_PATH}/db.sqlite\" && -d /opt/feather/db.sqlite ]] && cp -pr /opt/feather/db.sqlite \${BASE_PATH}/

[[ ! -d \"\${BASE_PATH}/Public\" && -d /opt/feather/Public ]] && cp -pr /opt/feather/Public \${BASE_PATH}/"

[[ ! -d \"\${BASE_PATH}/Resources\" && -d /opt/feather/Resources ]] && cp -pr /opt/feather/Resources \${BASE_PATH}/

Feather serve --hostname 0.0.0.0 --port \${BASE_PORT}
```

## Examples

```
docker run -d -v <LOCAL FOLDER>:/var/feather  -p 8080:8080  feather
```

```
docker run -d \
    -v <LOCAL FOLDER>:/var/feather \
    -e BASE_URL="http://localhost:8081" \
    -e BASE_PORT=8081 \
    -e DB_TYPE=mysql \
    -e DB_HOST=<MYSQL DB HOSTNAME> \
    -e DB_PORT=3306 \
    -e DB_NAME=feather \
    -e DB_USER=feather \
    -e DB_PASS=feather \
    -e MAX_BODYSIZE="10mb" \
    -d feather

```


## Known issues

### Postgress database

When running the app using a Postgres database, the index lenght is limited to 63 characthers trucating some of feather indentifier:
```
identifier "uq:user_permissions.module+user_permissions.context+user_permissions.action" will be truncated to "uq:user_permissions.module+user_permissions.context+user_permis" (truncate_identifier)
identifier "uq:frontend_metadatas.module+frontend_metadatas.model+frontend_metadatas.reference" will be truncated to "uq:frontend_metadatas.module+frontend_metadatas.model+frontend_" (truncate_identifier)
```

Until the issue is resolved, postgres databases are unusable.

## Credits

- [Vapor](https://vapor.codes) - underlying framework
- [Feather icons](https://feathericons.com) - feather icons


### License

[WTFPL](LICENSE)

