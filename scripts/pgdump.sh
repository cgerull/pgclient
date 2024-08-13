#!/bin/sh
#
export PGDUMP_DIR=/backup
export TS=$(date '+%Y-%m-%d-%H-%M')
echo "$(date '+%Y-%m-%d-%H-%M') -- Starting PostgreSql dump of all databases." > "${PGDUMP_DIR}/${TS}"-dump.log
pg_dumpall --clean --if-exists --load-via-partition-root --quote-all-identifiers \
    --no-password --verbose  2>>"${PGDUMP_DIR}/${TS}"-dump.log | gzip - >  "${PGDUMP_DIR}/${TS}"-pg_dumpall.sql.gz \
    && echo "$(date '+%Y-%m-%d-%H-%M') -- PostgreSql dump finished." >> "${PGDUMP_DIR}/${TS}"-dump.log
