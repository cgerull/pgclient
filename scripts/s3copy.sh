#!/bin/sh
#
# Check if environment variables exist
if [ -z "$MINIO_ACCESS_KEY" ] || [ -z "$MINIO_SECRET_KEY" ] || [ -z "$MINIO_ENDPOINT" ] || [ -z "$BUCKET_NAME" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Error: Missing required environment variables."
    exit 1
fi

MC_HOST_MINIO="http://${MINIO_ACCESS_KEY}:${MINIO_SECRET_KEY}@${MINIO_ENDPOINT#http://}"
export MC_HOST_MINIO
PGDUMP_DIR="${BACKUP_DIR:-/backup}"
export PGDUMP_DIR
echo "Saving latest PostgreSql dump to MinIO."
LATEST_DUMP="$(ls -t "${PGDUMP_DIR}"/*.gz | head -n 1)"
mcli -C /tmp cp "${LATEST_DUMP}"  "MINIO/${BUCKET_NAME}/$(basename ${LATEST_DUMP})"
LATEST_LOG="$(ls -t "${PGDUMP_DIR}"/*.log | head -n 1)"
mcli -C /tmp cp "${LATEST_LOG}"  "MINIO/${BUCKET_NAME}/$(basename ${LATEST_LOG})"
echo "PostgreSql dump saved to MINIO/${BUCKET_NAME}/${LATEST_DUMP}."
