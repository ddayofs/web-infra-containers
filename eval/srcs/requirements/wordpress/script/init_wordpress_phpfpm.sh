#!/bin/bash

# 스크립트 실행 중 오류 발생시 스크립트 종료(종료 코드 0이 아닌 경우)
set -e

# 환경 변수 설정 (필요시 docker-compose.yml에서 전달 가능)
DB_NAME=${MYSQL_DATABASE:-wordpress_phpfpm_database}
DB_USER=${MYSQL_USER:-donglee2}
DB_PASSWORD=${MYSQL_PASSWORD:-42}
DB_HOST=mariadb

# PHP-FPM 설정 파일 복사
cp /tmp/php-fpm.d/www.conf /etc/php/*/fpm/pool.d/www.conf

# PHP-FPM 소켓 디렉토리 및 권한 설정
mkdir -p /run/php
chown -R www-data:www-data /run/php
chmod -R 755 /run/php

# /var/www/html 디렉토리 생성 및 권한 설정
mkdir -p /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# 워드프레스 다운로드 및 설치
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
	echo "Downloading WordPress..."
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r ./wordpress/* /var/www/html/wordpress
	rm -rf ./wordpress
    chown -R www-data:www-data /var/www/html/wordpress
    chmod -R 755 /var/www/html/wordpress
    rm latest.tar.gz
fi

# PHP-FPM 설정 변경
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/*/fpm/php.ini

# wp-config.php 생성 및 데이터베이스 정보 설정
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
   	echo "Changing ownership of wp-config.php..."
    chown www-data:www-data /var/www/html/wordpress/wp-config.php || echo "Failed to change ownership"
    chmod 755 /var/www/html/wordpress/wp-config.php || echo "Failed to change permissions"
    ls -l /var/www/html/wordpress/wp-config.php
	echo "Configuring WordPress..."
	cp /var/www/html/wordpress/wp-config.php /tmp/wp-config.php
	sed -i "s/database_name_here/$DB_NAME/" /tmp/wp-config.php
	sed -i "s/username_here/$DB_USER/" /tmp/wp-config.php
	sed -i "s/password_here/$DB_PASSWORD/" /tmp/wp-config.php
	sed -i "s/localhost/$DB_HOST/" /tmp/wp-config.php
	mv /tmp/wp-config.php /var/www/html/wordpress/wp-config.php
fi

# 워드프레스 CLI 설치
# if ! command -v wp &> /dev/null; then
if ! command -v wp; then
  echo "Installing WordPress CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  echo "WordPress CLI installed."
else
  echo "WordPress CLI already installed."
fi

# MariaDB 준비 상태 확인
# 아래, is-installed 명령어가 db접속을 할 수 있어야, 명령어에 대한 결과가 정확하게 나오기 때문에 실행한다.

until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "status" &>/dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done
echo "MariaDB ready!!"

# 기존 데이터 확인
# is-inatalled는 설치경로에 wp-config.php 파일이 존재하는지 확인하고 여기에 명세된 DB애 연결을 시도한다.
# 연결된 DB에 핵심 테이블(e.g, wp_options, wp_users)이 존재하는지 확인한다. 이 과정이 모두 확인되면 설치되었음으로 간주.

if su -s /bin/bash www-data -c "wp core is-installed --path=/var/www/html/wordpress"; then
    echo "WordPress is already installed. Skipping installation steps."
else
    echo "WordPress is not installed. Running installation steps..."
    
    # WordPress 초기화 및 관리자 계정 생성
    su -s /bin/bash www-data -c "wp core install --url='http://localhost' \
        --title='$WP_TITLE' --admin_user='$WP_ADMIN_USER' \
        --admin_password='$WP_ADMIN_USER_PW' --admin_email='$WP_ADMIN_USER_EMAIL' \
        --path='/var/www/html/wordpress' --skip-email"

    su -s /bin/bash www-data -c "wp user create '$WP_USER' '$WP_USER_EMAIL' \
        --role=subscriber --user_pass='$WP_USER_PW' --path='/var/www/html/wordpress'"
fi

exec $@

