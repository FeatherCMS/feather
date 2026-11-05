#!/bin/sh
set -e

minio server /data --console-address ":9001" &
MINIO_PID=$!

until wget -q -O /dev/null http://localhost:9000/minio/health/ready; do
    sleep 1
done

mc alias set local http://localhost:9000 \
    "${MINIO_ROOT_USER}" \
    "${MINIO_ROOT_PASSWORD}"

mc admin accesskey create local "${MINIO_ROOT_USER}" \
    --access-key "${MINIO_ACCESS_KEY_ID}" \
    --secret-key "${MINIO_SECRET_ACCESS_KEY}" \
    || echo "Access key already exists"

mc mb "local/${MINIO_BUCKET_NAME}" \
    || echo "Bucket already exists"

mc anonymous set download "local/${MINIO_BUCKET_NAME}"

wait "$MINIO_PID"
