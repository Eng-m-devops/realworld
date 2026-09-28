# RealWorld Application - Enterprise DevOps Infrastructure

مرحباً بك في وثائق البنية التحتية لمنظومة **RealWorld Application**. يهدف هذا الدليل الشامل لشرح المعمارية الفنية وكيفية تشغيل وأتمتة ومراقبة النظام باستخدام أفضل الممارسات في مجال الـ **DevOps**.

---

## معمارية النظام (DevOps Architecture Diagram)

![RealWorld DevOps Architecture](docs/devops_architecture.png)

---

## التقنيات المستخدمة (Tech Stack)

- **Infrastructure as Code (IaC)**: OpenTofu / Terraform
- **Cloud Provider**: AWS (EC2 Ubuntu 24.04 LTS, Security Groups, 20GB GP3 EBS)
- **Configuration Management**: Ansible
- **Containerization & Orchestration**: Docker & Docker Compose
- **Reverse Proxy & Web Server**: Host-level Nginx (Ports 80 / 443)
- **Backend Application**: Django (Gunicorn WSGI)
- **Frontend Application**: React SPA (Production Build Nginx)
- **Database**: PostgreSQL 15 (Alpine)
- **CI/CD Pipeline**: GitHub Actions
- **Monitoring & Observability**: Prometheus & Grafana

---

## وثائق الخدمات المخصصة (Detailed Documentation)

لكل خدمة وثيقة مستقلة ومخطط رسومي توضيحي مخصص داخل مجلد `docs/`:

- **[معمارية Docker والحاويات](docs/DOCKER.md)**: تفاصيل عزل الحاويات وشبكة التواصل الداخلية.
- **[خط النشر الآلي CI/CD](docs/CICD.md)**: خطوات بناء البايبلاين، الاختبارات والنشر الآلي عبر GitHub Actions.
- **[البنية التحتية السحابية IaC](docs/INFRASTRUCTURE.md)**: شرح موارد AWS و OpenTofu و Ansible.
- **[منظومة المراقبة والتحليلات](docs/MONITORING.md)**: تفاصيل إعداد Prometheus و Grafana والتنبيهات.

---

## تفاصيل البنية التحتية (Architecture Components)

### 1. السيرفر والشبكات (Cloud & OS)

- **سيرفر EC2 (t3.micro)** يعمل بنظام Ubuntu 24.04 LTS.
- **وحدة التخزين**: 20GB GP3 SSD لمنح مساحة كافية للـ Docker Layers والـ Logs.
- **إدارة الذاكرة**: تخصيص 2GB Swap Memory لمنع انقطاع الخدمات عند ارتفاع الاستهلاك (OOM Prevention).
- **الجدار الناري (Security Group)**:
  - `Port 22`: مفتوح للاتصال الآمن عبر SSH.
  - `Port 80`: استقبال حركة مرور HTTP.
  - `Port 443`: التشفير الآمن عبر شهادات HTTPS/SSL.

### 2. الشبكة الداخلية وعزل الحاويات (Networking & Proxy)

- **Host Nginx Proxy**: يعمل مباشرة على السيرفر لتوجيه الحركة:
  - `/` -> يوجه إلى حاوية React الواجهة الأمامية (`127.0.0.1:8080`).
  - `/api/` -> يوجه إلى حاوية Django الـ Backend (`127.0.0.1:8000`).
- **عزل الحاويات**: الحاويات مغلقة محلياً ولا يمكن الوصول المباشر لقواعد البيانات أو الحاويات من خارج السيرفر إلا عبر Nginx.

### 3. المراقبة والمتابعة (Monitoring Stack)

- **Prometheus (Port 9090)**: تجميع واستعلام المقاييس والبيانات التشغيلية.
- **Grafana (Port 3000)**: لوحات تحكم تفاعلية لمتابعة صحة المعالج، الذاكرة، وقاعدة البيانات.

---

## دليل النشر والتشغيل (Deployment Guide)

### 1️⃣ تجهيز البنية التحتية (OpenTofu / Terraform)

```bash
cd terrform
tofu init
tofu plan
tofu apply -auto-approve
```

### 2️⃣ تهيئة وتجهيز السيرفر (Ansible)

```bash
cd ../ansible

# 1. تثبيت وتجهيز السيرفر والـ Swap و Docker
ansible-playbook -i hosts.ini setup-server.yml

# 2. نشر التطبيق والـ Nginx الرئيسية
ansible-playbook -i hosts.ini playbook.yml

# 3. تشغيل منظومة المراقبة Prometheus & Grafana
ansible-playbook -i hosts.ini monitoring.yml
```

---

## خط النشر الآلي (CI/CD Pipeline)

عند إجراء أي `git push` إلى فرع `production`:

1. يتم تشغيل **GitHub Actions Workflow** تلقائياً.
2. بناء صور Docker وتحديد إصداره بـ Git Commit SHA.
3. رفع الصور إلى **Docker Hub**.
4. الاتصال بالسيرفر عبر SSH وتشغيل التحديث الآلي بدون توقف الخدمة (Zero-Downtime Deployment).

---

## اختبار واستقرار النظام (Health & E2E Testing)

- **الواجهة الرئيسية**: `http://54.80.244.31/`
- **الـ API Endpoint**: `http://54.80.244.31/api/articles`
- **لوحة Grafana**: `http://54.80.244.31:3000`
- **Prometheus**: `http://54.80.244.31:9090`
