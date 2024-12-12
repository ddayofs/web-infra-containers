# Debian 베이스 이미지 사용
FROM debian:bullseye

# Nginx 설치
RUN apt-get update && \
    apt-get install -y dumb-init nginx openssl vim && \
    apt-get clean 

# 스크립트 파일 복사
COPY ./script/init_nginx.sh /tmp/init_nginx.sh

# 실행 권한 부여
RUN chmod +x /tmp/init_nginx.sh

# SSL 인증서 및 키 생성
# Nginx는 HTTPS 설정 시 /etc/nginx/ssl 내의 인증서와 키를 참조
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/private.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Nginx 설정 복사
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# # Nginx 포트 노출
# EXPOSE 443

# Nginx 실행
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["dumb-init", "--", "/tmp/init_nginx.sh"]
CMD ["nginx", "-g", "daemon off;"]
