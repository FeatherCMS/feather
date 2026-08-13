#!/usr/bin/env sh

set -eu

mkdir -p /certs
openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /certs/server.key \
    -out /certs/server.crt \
    -days 3650 \
    -subj "/CN=localhost"
cp /certs/server.crt /certs/ca.pem

