FROM postgres:18.6

WORKDIR /var/lib/postgresql

COPY docker/postgres/scripts/config-ssl.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/config-ssl.sh

