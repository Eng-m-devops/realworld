# Stage 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json .

RUN npm install 

COPY . .

RUN npm run build


FROM nginx:alpine
# نسخ إعدادات Nginx المخصصة لتقديم ملفات React داخل الحاوية
COPY nginx.conf /etc/nginx/conf.d/default.conf

# نسخ ملفات البناء
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

