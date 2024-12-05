# Debian 베이스 이미지 사용
FROM debian:bullseye

# Nginx 설치
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean 

# SSL 인증서 및 키 생성
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/private.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Nginx 설정 복사
COPY default.conf /etc/nginx/conf.d/default.conf

# Nginx 포트 노출
EXPOSE 443

# Nginx 실행
ENTRYPOINT ["nginx", "-g", "daemon off;"]
