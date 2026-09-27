# 🏗️ AWS Infrastructure Template (OpenTofu / Terraform)

هذا القالب يُستخدم لبناء السيرفر والشبكات الأساسية على سحابة **AWS** باستخدام **OpenTofu** أو **Terraform**.

---

## 📁 ملفات القالب (Template Structure)

* `main.tf`: التعريف الرئيسي للموارد (EC2, Security Groups, SSH Key, EBS Volume).
* `variables.tf`: التعريف والمتغيرات والقيم الافتراضية.
* `outputs.tf`: المخرجات الرئيسية بعد البناء (عنوان IP العام للسيرفر).
* `terraform.tfvars.example`: مثال للقيم القابلة للتخصيص.

---

## 🚀 طريقة الاستخدام (Usage Guide)

1. **انسخ ملف المتغيرات**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **هيئ ملحقات OpenTofu/Terraform**:
   ```bash
   tofu init   # أو terraform init
   ```

3. **استعرض الموارد التي سيتم بناؤها**:
   ```bash
   tofu plan   # أو terraform plan
   ```

4. **نفّذ عملية البناء**:
   ```bash
   tofu apply  # أو terraform apply
   ```
