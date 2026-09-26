FROM python:3.11-slim

WORKDIR /app

# تثبيت متطلبات النظام المساعدة
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# نسخ سكريبت الإقلاع وإعطاء صلاحيات التنفيذ
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# تشغيل خادم الإنتاج Gunicorn بدلاً من runserver
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "conduit.wsgi:application"]