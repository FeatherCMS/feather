# Use the official PostgreSQL image
FROM postgres:18.4

# Update package lists, install netcat-openbsd (useful for waiting on network connections), and clean up apt cache
#RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/lib/postgresql

RUN rm -rf data/*

# Copy an initialization script that sets up SSL into the Docker entrypoint directory
# Scripts in this directory are executed when the container is initialized
COPY docker/postgres/scripts/config-ssl.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/config-ssl.sh

# Expose the PostgreSQL default port to allow external connections
EXPOSE 5432
