#!/bin/sh
set -e

# Append SSL configuration to postgresql.conf
cat >>"$PGDATA/postgresql.conf" <<'EOF'
ssl = on
ssl_cert_file = '/certs/server.pem'
ssl_key_file = '/certs/server.key'
ssl_ca_file = '/certs/ca.pem'
EOF

# Allow SSL connections only
cat >"$PGDATA/pg_hba.conf" <<'EOF'
local all all trust
hostssl all all 0.0.0.0/0 md5
hostssl all all ::/0 md5
EOF
