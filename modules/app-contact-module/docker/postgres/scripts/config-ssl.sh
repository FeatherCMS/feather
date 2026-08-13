#!/usr/bin/env bash

set -euo pipefail

cat > /docker-entrypoint-initdb.d/ssl.sql <<'SQL'
ALTER SYSTEM SET ssl = 'on';
ALTER SYSTEM SET ssl_ca_file = '/certs/ca.pem';
ALTER SYSTEM SET ssl_cert_file = '/certs/server.crt';
ALTER SYSTEM SET ssl_key_file = '/certs/server.key';
SQL

