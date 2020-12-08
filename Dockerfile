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

## Build executable
RUN apt-get update && apt-get install minify libxml2-dev libsqlite3-dev -y
RUN swift build -c release
RUN mv .build/x86_64-unknown-linux-gnu/release bin

## Prepare Public folder template
RUN rm -rf Public/assets
RUN rm -rf */**/.DS_Store
RUN minify --all Public/css/admin.css > Public/css/admin.min.css
RUN minify --all Public/css/frontend.css > Public/css/frontend.min.css
RUN rm Public/css/frontend.css Public/css/admin.css
RUN minify --all Public/javascript/admin.js > Public/javascript/admin.min.js
RUN mv Public/javascript/admin.min.js Public/javascript/admin.js

## Clean up
RUN mv Public /tmp/app && mv bin /tmp/app
RUN cd /; rm -rf /opt/feather; mv /tmp/app /opt/feather

## User feather
RUN groupadd -r feather && useradd --no-log-init -r -g feather feather
RUN chown -R feather:feather /opt/feather
RUN chmod 550 /opt/feather/bin/Feather


## Slim version
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

