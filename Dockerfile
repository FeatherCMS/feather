FROM swift:5.3.3-focal as builder
WORKDIR /opt/feather

COPY . .

## Install required dependencies for the build
RUN apt-get update && apt-get install libxml2-dev libsqlite3-dev -y

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
    swift build -c release --enable-test-discovery; \
else \
    swift build -c release --enable-test-discovery; \
fi

RUN rm -rf */**/.DS_Store

## Organizing things up
RUN mkdir -p /tmp/app

## Check if the folder contains preexising DB/Folders.
## It means the user may have prepare Feather-CMS locally, in that case we will copy its content to the template folder
## So the user will keep what he prepared
RUN cd /opt/feather; if [ -f "db.sqlite" ]; then cp -pr db.sqlite /tmp/app; fi
RUN cd /opt/feather; if [ -d "Public" ]; then cp -pr Public /tmp/app; fi
RUN cd /opt/feather; if [ -d "Resources" ]; then cp -pr Resources /tmp/app; fi

## Prepare entry point
RUN \
echo '#!/bin/bash' > /tmp/app/start &&\
echo "[[ ! -d \"\${BASE_PATH}/db.sqlite\" && -d /opt/feather/db.sqlite ]] && cp -pr /opt/feather/db.sqlite \${BASE_PATH}/" >> /tmp/app/start &&\
echo "[[ ! -d \"\${BASE_PATH}/Public\" && -d /opt/feather/Public ]] && cp -pr /opt/feather/Public \${BASE_PATH}/" >> /tmp/app/start &&\
echo "[[ ! -d \"\${BASE_PATH}/Resources\" && -d /opt/feather/Resources ]] && cp -pr /opt/feather/Resources \${BASE_PATH}/" >> /tmp/app/start &&\
echo "Feather serve --hostname 0.0.0.0 --port \${BASE_PORT}" >> /tmp/app/start
RUN chmod 550 /tmp/app/start

## Keep only executables & resources (will be available in /opt/feather/bin )
RUN mv /opt/feather/.build/x86_64-unknown-linux-gnu/release /tmp/app/bin

## Copy any custom scripts under the `customscripts` folder
## If the user decide to use a diffent enty point from start, he can create hsi own scripts. 
## Ex. We could imagine, starting 10 servers in one docker. The script would set, different folders, env variables. It will not work with embeded DB here...
## docker run -d -p 8080-8090:8080-8090 feather start_10_apps
RUN if [ -d "/opt/feather/customscripts" ]; then  \
 chmod 550 /opt/feather/customscripts/*; \
 cp -pr /opt/feather/customscripts/* /tmp/app/; \
fi

## Clean up & keep only executbale from the build
RUN cd /; rm -rf /opt/feather; mv /tmp/app /opt/feather

## User feather
RUN groupadd -r feather && useradd --no-log-init -r -g feather feather
RUN chown -R feather:feather /opt/feather
RUN chmod 550 /opt/feather/bin/Feather



## Slim version of the container
FROM swift:5.3.3-focal-slim
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
ENV DB_TYPE="sqlite"
ENV MAX_BODYSIZE="10mb"
ENV USE_FILE_MIDDLEWARE="true"

## Using mysql/mariadb/postgres
ENV DB_HOST="localhost"
# ENV DB_PORT=3306 or 5432 # The port will use the default one, if you use a custom port, set this env variable
ENV DB_USER="feather"
ENV DB_PASS="feather"
ENV DB_NAME="feather"

CMD [ "bash", "/opt/feather/start" ]

