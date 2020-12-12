FROM swift:latest as builder
WORKDIR /opt/feather

COPY . .

## Temp folder
RUN mkdir -p /tmp/app

## Prepare entry point
RUN \
echo "# #!/bin/bash --env" >> /tmp/app/init.sh &&\
echo "[ ! -d \"\${BASE_PATH}/Public\" ] && cp -pr /opt/feather/Public \${BASE_PATH}/" >> /tmp/app/init.sh &&\
echo "Feather serve --hostname 0.0.0.0 --port \${BASE_PORT}" >> /tmp/app/init.sh
RUN chmod 550 /tmp/app/init.sh

## Install required dependencies for the buil
RUN apt-get update && apt-get install minify libxml2-dev libsqlite3-dev -y

## Allow the usage of private repository
### This part is for advanced user, ignore it if you don't use private repository in Swift package manager
## 1. Add SSH Hostname to known_host (This is use for Private repo in SPM)
## Here we add github.com hostname as when building the docker file we don't have an interactive shell
## It means it will be known from git, so won't request confirmation of the key
## You may want to add your own
## 2. It will use you private keys to clone private repository
## You private keys should be stored (Password less, decrypted) in the folder `ssh`
## for Continous integration, you will need a step to copy the decrypted key to the folder. Symbolic link won't work
RUN if [ -d "ssh" ]; then \ 
 mkdir -p ~/.ssh/; \
 eval `ssh-agent`; \
 ssh-keyscan -H github.com  >> ~/.ssh/known_hosts; \
fi

## Build the application
RUN echo "---> Build application"; \
if [ -d "ssh" ]; then \ 
    eval `ssh-agent`; \
    chmod 400 ssh/*; \
    ssh-add ssh/*; \
    swift build -c release; \
else \
    swift build -c release; \
fi
RUN mv .build/x86_64-unknown-linux-gnu/release bin

## Check if the db.sqlite is  present.
## It means the user may have prepare feather locally, in that case we will copy the db.sqlite to the template folder
## So the user will keep what he prepared
RUN if [ -f "db.sqlite" ]; then cp -pr db.sqlite /tmp/app; fi

## Create the Default - Public folder (if it wasn't already provided)
ENV BASE_URL="http://localhost:8080"
ENV BASE_PATH="/opt/feather"
RUN echo "---> Get current Public folder" &&\
bin/Feather serve --hostname 0.0.0.0 &


### In this part we will minify CSS & JS
## If you alredy provided those file minified, remove it

## Prepare Public folder template (We will minify any CSS/Javascript)
RUN sleep 5; && rm -rf */**/.DS_Store
RUN echo "---> Minify css" &&\
for filename in Public/css/*.css; do \
    name=$(echo "$filename" | cut -f 1 -d '.'); \
    [ ! -f Public/css/$name.min.css ] && minify --all Public/css/$name.css > Public/css/$name.min.css; \
    [ -f Public/css/$name.min.css ] && rm Public/css/$name.css; \
done

## Please note that the default application is not using <name>.min.js file
## if you want to minify your js, they should be stored as <name>.js
RUN echo "---> Minify javascript" &&\
for filename in Public/javascript/*.js; do \
    name=$(echo "$filename" | cut -f 1 -d '.'); \
    [ ! -f Public/javascript/$name.min.js ] && minify --all Public/javascript/$name.js > Public/javascript/$name.min.js; \
    [ -f Public/javascript/$name.min.js ] && mv Public/javascript/$name.min.js Public/javascript/$name.js; \
done

## Clean up
RUN mv Public /tmp/app && mv bin /tmp/app
RUN cd /; rm -rf /opt/feather; mv /tmp/app /opt/feather

## User feather
RUN groupadd -r feather && useradd --no-log-init -r -g feather feather
RUN chown -R feather:feather /opt/feather
RUN chmod 550 /opt/feather/bin/Feather



## Slim version of the container
FROM swift:slim
WORKDIR /var/feather
COPY --from=builder /opt/feather /opt/feather

RUN \
 groupadd -r feather &&\
 useradd --no-log-init -r -g feather feather &&\
 mkdir -p /var/feather && chown -R feather:feather /var/feather &&\
 ln -s /opt/feather/bin/Feather /usr/local/bin/

USER feather

ENV BASE_URL="http://localhost:8080"
ENV BASE_PORT=8080
ENV BASE_PATH="/var/feather"

## Default sqlite
ENV DBTYPE="sqlite"
ENV MAX_BODYSIZE="10mb"

## Using mysql/mariadb/postgres
ENV SQL_HOST="localhost"
# ENV SQL_PORT=3306 or 5432 # The port will use the default one, if you use a custom port, set this env variable
ENV SQL_USER="feather"
ENV SQL_PASSWORD="feather"
ENV SQL_DATABASE="feather"

CMD [ "sh", "/opt/feather/init.sh" ]

