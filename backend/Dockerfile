FROM python:3.11-slim

WORKDIR /app

# تثبيت متطلبات النظام المساعدة وإنشاء مستخدم غير جذر
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc postgresql-client && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1000 appuser

COPY requirements.txt .

# تحديث الأدوات الأساسية وإجبار التحديث على الإصدارات الآمنة
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" wheel && \
    pip install --no-cache-dir --upgrade -r requirements.txt

COPY . .
RUN rm -rf /app/venv /app/.venv /app/env /app/__pycache__

# نسخ سكريبت الإقلاع وإعطاء صلاحيات التنفيذ
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R appuser:appuser /app /entrypoint.sh

USER appuser

ENTRYPOINT ["/entrypoint.sh"]

# تشغيل خادم الإنتاج Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "conduit.wsgi:application"]