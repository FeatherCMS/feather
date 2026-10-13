#!/bin/sh
set -e

CERT_DIR="${CERT_DIR:-/certs}"

mkdir -p "${CERT_DIR}"
cd "${CERT_DIR}"

if [ -f server.pem ] && [ -f server.key ] && [ -f ca.pem ]; then
  echo "Certificates already exist in ${CERT_DIR}"
  exit 0
fi

# Generate CA (Certificate Authority) private key
openssl genpkey -algorithm RSA -out ca.key

# Generate CA certificate (PEM format)
openssl req -new -x509 -key ca.key -out ca.pem -days 365 -subj "/CN=PostgreSQL-CA"

# Generate server private key
openssl genpkey -algorithm RSA -out server.key

# Create a CSR with correct CN (Common Name) & SAN (Subject Alternative Name)
openssl req -new -key server.key -out server.csr -subj "/CN=localhost"

# SAN for localhost, db, host.docker.internal, and 127.0.0.1
echo "subjectAltName=DNS:localhost,DNS:db,DNS:host.docker.internal,IP:127.0.0.1" >san.cnf

# Sign the server certificate with CA & SAN
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -days 365 -extfile san.cnf

# Keep only what consumers need in the shared volume.
rm -f server.csr san.cnf ca.srl

# postgres image runs as uid/gid 999
chown 999:999 server.key server.pem
chmod 600 server.key
chmod 644 server.pem ca.pem
