
# 베이스 이미지로 Debian 사용
FROM debian:bullseye

ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

# dumb-init 설치
RUN apt-get update && \
	apt-get install -y dumb-init mariadb-server mariadb-client vim && \
	# apt-get install -y dumb-init mariadb-server vim && \
	apt-get clean

# # 스크립트 파일 복사
# COPY ./script/init_mariadb.sh /usr/local/bin/init_mariadb.sh

# # 실행 권한 부여
# RUN chmod +x /usr/local/bin/init_mariadb.sh

# # MariaDB 초기화
# RUN service mariadb start && \
#     echo "Waiting for MariaDB to initialize..." && \
#     until mysqladmin ping --silent; do sleep 2; done && \
#     mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" && \
#     mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" && \
#     mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" && \
    # mysql -e "FLUSH PRIVILEGES;"

RUN	service mariadb start && \
    # echo "Waiting for MariaDB to initialize..." && \
    # until mysqladmin ping --silent; do sleep 2; done && \
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" && \
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" && \
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" && \
    mysql -e "FLUSH PRIVILEGES;"

# MariaDB 포트 노출
EXPOSE 3306

# # ENTRYPOINT를 dumb-init과 init_mariadb.sh로 설정
# ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/init_mariadb.sh"]
# # ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
# CMD ["mysqld", "--bind-address=0.0.0.0"]

ENTRYPOINT ["mysqld", "--bind-address=0.0.0.0"]
