#!/bin/bash

# 환경 변수 설정 (필요시 docker-compose.yml에서 전달 가능)
DB_NAME=${MYSQL_DATABASE:-wordpress_database}
DB_USER=${MYSQL_USER:-donglee2}
DB_PASSWORD=${MYSQL_PASSWORD:-donglee2}
DB_HOST=mariadb

# PHP-FPM 설정 파일 복사
cp /usr/local/etc/php-fpm.d/www.conf /etc/php/*/fpm/pool.d/www.conf

# PHP-FPM 소켓 디렉토리 및 권한 설정
mkdir -p /run/php
chown -R www-data:www-data /run/php

# /var/www/html 디렉토리 생성 및 권한 설정
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

touch /bugssssssss1

# 워드프레스 다운로드 및 설치
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r ./wordpress/* /var/www/html/wordpress
	rm -rf ./wordpress
    chown -R www-data:www-data /var/www/html/wordpress
    chmod -R 755 /var/www/html/wordpress
    rm latest.tar.gz
	touch /bugssssssss2
fi

touch /bugssssssss3

# PHP-FPM 설정 변경
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/*/fpm/php.ini

# wp-config.php 생성 및 데이터베이스 정보 설정
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
    sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
    sed -i "s/localhost/$DB_HOST/" /var/www/html/wordpress/wp-config.php
fi


# PHP-FPM 실행
exec "$@"

