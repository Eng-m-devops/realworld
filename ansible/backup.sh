#!/bin/bash
# =================================================================
# PostgreSQL Automated Database Backup Script
# =================================================================
set -e

BACKUP_DIR="/var/backups/postgres"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7
BACKUP_FILE="${BACKUP_DIR}/db_backup_${TIMESTAMP}.sql.gz"

mkdir -p "${BACKUP_DIR}"

# العثور على اسم أو معرف حاوية قاعدة البيانات
CONTAINER_NAME=$(docker ps --format '{{.Names}}' | grep -E 'db|postgres' | head -n 1)

if [ -z "${CONTAINER_NAME}" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Database container is not running!" >&2
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting PostgreSQL backup from container: ${CONTAINER_NAME}..."

# أخذ النسخة الاحتياطية وضغطها
docker exec -t "${CONTAINER_NAME}" pg_dumpall -U postgres | gzip > "${BACKUP_FILE}"

# التحقق من نجاح العملية وحجم الملف
if [ -s "${BACKUP_FILE}" ]; then
    SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup successfully created: ${BACKUP_FILE} (Size: ${SIZE})"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Backup file is empty!" >&2
    rm -f "${BACKUP_FILE}"
    exit 1
fi

# حذف النسخ الاحتياطية القديمة الأقدم من 7 أيام
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -type f -name "db_backup_*.sql.gz" -mtime +${RETENTION_DAYS} -exec rm -vf {} \;

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup process finished successfully."
