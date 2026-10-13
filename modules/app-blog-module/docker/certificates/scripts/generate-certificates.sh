#!/bin/sh
set -e

CERT_DIR="${CERT_DIR:-/certs}"
mkdir -p "${CERT_DIR}"
cd "${CERT_DIR}"

if [ -f server.pem ] && [ -f server.key ] && [ -f ca.pem ]; then
  exit 0
fi

openssl genpkey -algorithm RSA -out ca.key
openssl req -new -x509 -key ca.key -out ca.pem -days 365 -subj "/CN=PostgreSQL-CA"
openssl genpkey -algorithm RSA -out server.key
openssl req -new -key server.key -out server.csr -subj "/CN=localhost"
echo "subjectAltName=DNS:localhost,DNS:postgres,IP:127.0.0.1" > san.cnf
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -days 365 -extfile san.cnf
rm -f server.csr san.cnf ca.srl
chown 999:999 server.key server.pem
chmod 600 server.key
chmod 644 server.pem ca.pem
