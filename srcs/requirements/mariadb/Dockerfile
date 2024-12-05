ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

# 베이스 이미지로 Debian 사용
FROM debian:bullseye

# dumb-init 설치
RUN apt-get update && \
	apt-get install -y dumb-init mariadb-server mariadb-client vim && \
	# apt-get install -y dumb-init mariadb-server vim && \
	apt-get clean

# # 스크립트 파일 복사
# COPY ./script/init_mariadb.sh /usr/local/bin/init_mariadb.sh

# # 실행 권한 부여
# RUN chmod +x /usr/local/bin/init_mariadb.sh

RUN service mariadb start && \
	# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '42';" && \
	mysql -e "CREATE DATABASE IF NOT EXISTS wordpress_phpfpm_database;" && \
	mysql -e "CREATE USER IF NOT EXISTS 'donglee2'@'%' IDENTIFIED BY '42';" && \
	mysql -e "GRANT ALL PRIVILEGES ON wordpress_phpfpm_database.* TO 'donglee2'@'%';" && \
	mysql -e "FLUSH PRIVILEGES;"

# MariaDB 포트 노출
EXPOSE 3306

# # ENTRYPOINT를 dumb-init과 init_mariadb.sh로 설정
# ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/init_mariadb.sh"]
# # ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
# CMD ["mysqld", "--bind-address=0.0.0.0"]

ENTRYPOINT ["mysqld", "--bind-address=0.0.0.0"]
