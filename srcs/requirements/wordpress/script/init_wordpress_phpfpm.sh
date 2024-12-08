#!/bin/bash

# 환경 변수 설정 (필요시 docker-compose.yml에서 전달 가능)
DB_NAME=${MYSQL_DATABASE:-wordpress_phpfpm_database}
DB_USER=${MYSQL_USER:-donglee2}
DB_PASSWORD=${MYSQL_PASSWORD:-42}
DB_HOST=mariadb

# 스크립트 실행 중 오류 발생시 스크립트 종료(종료 코드 0이 아닌 경우)
set -e

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

echo "debug 0"
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

echo "debug 1"
# 워드프레스 CLI 설치
if ! command -v wp &> /dev/null; then
  echo "Installing WordPress CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  echo "WordPress CLI installed."
else
  echo "WordPress CLI already installed."
fi

echo "debug 2"
# 데이터베이스 연결 확인
echo "Waiting for database connection..."
until wp db check --path=/var/www/html/wordpress --allow-root; do
  sleep 2
  echo "Retrying database connection..."
done
echo "debug 3"

# # 워드프레스 CLI를 사용해 유저 생성
# wp core install --url="http://localhost" --title="My WordPress Site" \
# 	--admin_user="main_admin" --admin_password="securepassword" --admin_email="admin@example.com" \
# 	--path="/var/www/html/wordpress" --skip-email

# # 관리자 계정 생성
# wp user create "secure_admin" "secure_admin@example.com" --role=administrator --user_pass="securepassword" \
# 	--path="/var/www/html/wordpress"

# # 일반 유저 생성
# wp user create "regular_user" "user@example.com" --role=subscriber --user_pass="userpassword" \
# 	--path="/var/www/html/wordpress"

# # www-data 사용자로 WordPress CLI 실행
# # 워드프레스 CLI를 사용해 유저 생성
# sudo -u www-data wp core install --url="http://localhost" --title="My WordPress Site" \
#     --admin_user="main_admin" --admin_password="securepassword" \
#     --admin_email="admin@example.com" --path="/var/www/html/wordpress" --skip-email

# # 관리자 계정 생성
# sudo -u www-data wp user create "secure_admin" "secure_admin@example.com" --role=administrator \
#     --user_pass="securepassword" --path="/var/www/html/wordpress"

# # 일반 유저 생성
# sudo -u www-data wp user create "regular_user" "user@example.com" --role=subscriber \
#     --user_pass="userpassword" --path="/var/www/html/wordpress"

su -s /bin/bash www-data -c "wp core install --url='http://localhost' \
    --title='My WordPress Site' --admin_user='main_admin' \
    --admin_password='securepassword' --admin_email='admin@example.com' \
    --path='/var/www/html/wordpress' --skip-email"

su -s /bin/bash www-data -c "wp user create 'secure_admin' 'secure_admin@example.com' \
    --role=administrator --user_pass='securepassword' --path='/var/www/html/wordpress'"

su -s /bin/bash www-data -c "wp user create 'regular_user' 'user@example.com' \
    --role=subscriber --user_pass='userpassword' --path='/var/www/html/wordpress'"

# PHP-FPM 실행
exec "$@"

