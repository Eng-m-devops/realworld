#!/bin/bash
# =================================================================
# PostgreSQL Database Restore Script
# =================================================================
set -e

BACKUP_FILE=$1

if [ -z "${BACKUP_FILE}" ]; then
    echo "Usage: $0 /path/to/backup.sql.gz"
    echo "Example: $0 /var/backups/postgres/db_backup_20261010_020000.sql.gz"
    exit 1
fi

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: Backup file '${BACKUP_FILE}' does not exist!" >&2
    exit 1
fi

CONTAINER_NAME=$(docker ps --format '{{.Names}}' | grep -E 'db|postgres' | head -n 1)

if [ -z "${CONTAINER_NAME}" ]; then
    echo "ERROR: Database container is not running!" >&2
    exit 1
fi

echo "WARNING: Restoring will overwrite existing data in PostgreSQL container '${CONTAINER_NAME}'."
echo "Restoring from: ${BACKUP_FILE}"

gunzip -c "${BACKUP_FILE}" | docker exec -i "${CONTAINER_NAME}" psql -U postgres

echo "Database restore completed successfully!"
