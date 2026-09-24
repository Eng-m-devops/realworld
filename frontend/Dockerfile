# Stage 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json .

RUN npm install 

COPY . .

RUN npm run build


FROM nginx:alpine
# إنشاء شهادة SSL ذاتية التوقيع لاستخدامها على الـ IP المباشر
RUN apk add --no-cache openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/selfsigned.key \
    -out /etc/nginx/ssl/selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=RealWorld/OU=DevOps/CN=100.48.89.109"

# نسخ إعدادات Nginx المخصصة لتوجيه الـ API والـ SSL
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]

