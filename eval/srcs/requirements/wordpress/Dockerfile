# 빌드 컨텍스트에서 전달받은 인자 사용
ARG DIR

# 베이스 이미지 설정
FROM debian:bullseye

# dumb-init 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y dumb-init wget curl unzip gnupg2 lsb-release php php-fpm \
	php-mysql vim mariadb-client && \
    apt-get clean

# PHP-FPM 소켓 디렉토리 및 /var/www/html 디렉토리 생성
RUN mkdir -p /run/php /var/www/html/wordpress && \
    chown -R www-data:www-data /run/php /var/www/html/wordpress && \
	chmod -R 755 /run/php /var/www/html/wordpress

# 스크립트 파일 복사
COPY ./script/init_wordpress_phpfpm.sh /tmp/init_wordpress_phpfpm.sh

# www.conf 파일 복사
COPY ./www.conf /tmp/php-fpm.d/www.conf

# 실행 권한 부여
RUN chmod +x /tmp/init_wordpress_phpfpm.sh 

# # PHP-FPM 포트 노출
# EXPOSE 9000

# ENTRYPOINT 설정
ENTRYPOINT ["dumb-init",  "--", "/tmp/init_wordpress_phpfpm.sh"]
CMD ["php-fpm7.4", "-F"]
