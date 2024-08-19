#!/bin/sh
#
# Check if environment variables exist
if [ -z "$MINIO_ACCESS_KEY" ] || [ -z "$MINIO_SECRET_KEY" ] || [ -z "$MINIO_ENDPOINT" ] || [ -z "$BUCKET_NAME" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Error: Missing required environment variables."
    exit 1
fi

PGDUMP_DIR="${BACKUP_DIR:-/backup}"
export PGDUMP_DIR
TS="$(date '+%Y-%m-%d-%H-%M')"
export TS
MC_HOST_MINIO="http://${MINIO_ACCESS_KEY}:${MINIO_SECRET_KEY}@${MINIO_ENDPOINT#http://}"
export MC_HOST_MINIO

# Dump databases seperatly
DATABASES=$(psql -t -A -c "SELECT datname FROM pg_database WHERE datname <> ALL ('{template0,template1,postgres}')")
for DB in $DATABASES; do
    echo "$(date '+%Y-%m-%d-%H-%M') -- Starting PostgreSql dump of database ${DB}." >> "${PGDUMP_DIR}/${TS}-${DB}-dump.log"
    pg_dump --clean --if-exists --create --load-via-partition-root --quote-all-identifiers \
        --no-password --verbose --dbname="${DB}" 2>>"${PGDUMP_DIR}/${TS}-${DB}-dump.log" | gzip - >  "${PGDUMP_DIR}/${TS}-${DB}.sql.gz" \
        && echo "$(date '+%Y-%m-%d-%H-%M') -- PostgreSql dump of database ${DB} finished." >> "${PGDUMP_DIR}/${TS}-${DB}-dump.log"
    echo "Saving ${TS}-${DB}-dump to MinIO."
    mcli -C /tmp cp "${PGDUMP_DIR}/${TS}-${DB}-dump.log"  "MINIO/${BUCKET_NAME}/${TS}-${DB}-dump.log"
    mcli -C /tmp cp "${PGDUMP_DIR}/${TS}-${DB}.sql.gz"  "MINIO/${BUCKET_NAME}/${TS}-${DB}.sql.gz"
done
