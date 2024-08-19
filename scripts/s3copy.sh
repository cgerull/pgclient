#!/bin/sh
#
MC_HOST_MINIO=http://${MINIO_ACCESS_KEY}:${MINIO_SECRET_KEY}@${MINIO_ENDPOINT#http://}
export MC_HOST_MINIO
PGDUMP_DIR=/tmp/backup
export PGDUMP_DIR
echo "Saving latest PostgreSql dump to MinIO."
LATEST_DUMP="$(ls -t "${PGDUMP_DIR}"/*.gz | head -n 1)"
mcli -C /tmp cp "${LATEST_DUMP}"  "MINIO/backups-{{ .Release.Namespace }}/$(basename ${LATEST_DUMP})"
LATEST_LOG="$(ls -t "${PGDUMP_DIR}"/*.log | head -n 1)"
mcli -C /tmp cp "${LATEST_LOG}"  "MINIO/backups-{{ .Release.Namespace }}/$(basename ${LATEST_LOG})"
echo "PostgreSql dump saved to MINIO/backups-{{ .Release.Namespace }}/${LATEST_DUMP}."
