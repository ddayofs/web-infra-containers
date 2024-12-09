# # # # #!/bin/bash

# # # # # 환경 변수 설정
# # # # MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
# # # # MYSQL_DATABASE=${MYSQL_DATABASE:-database}
# # # # MYSQL_USER=${MYSQL_USER:-user}
# # # # MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# # # # # MariaDB 서비스 시작
# # # # service mariadb start

# # # # # 데이터베이스 및 유저 생성
# # # # mysql -u root <<EOF
# # # # ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# # # # CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# # # # CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# # # # GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# # # # FLUSH PRIVILEGES;
# # # # EOF

# # # # # # 데이터베이스 및 유저 생성
# # # # # mysql -u root <<EOF
# # # # # ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
# # # # # CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
# # # # # CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# # # # # GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
# # # # # FLUSH PRIVILEGES;
# # # # # EOF

# # # # # MariaDB 실행
# # # # exec "$@"

# # # #!/bin/bash

# # # # 쉘 스크립트 실행 중 오류 발생 시 스크립트 종료
# # # set -e

# # # # 환경 변수 설정
# # # MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
# # # MYSQL_DATABASE=${MYSQL_DATABASE:-database}
# # # MYSQL_USER=${MYSQL_USER:-user}
# # # MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# # # # /run/mysqld 디렉토리 생성
# # # if [ ! -d "/run/mysqld" ]; then
# # #     echo "Creating /run/mysqld directory..."
# # #     mkdir -p /run/mysqld
# # #     chown -R mysql:mysql /run/mysqld
# # # fi

# # # # MariaDB 데이터 디렉토리 초기화
# # # if [ ! -d "/var/lib/mysql/mysql" ]; then
# # #     echo "Initializing MariaDB data directory..."
# # #     mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
# # # fi

# # # echo "debug -1"

# # # # MariaDB 데몬을 백그라운드에서 실행
# # # echo "Starting MariaDB in background..."
# # # mysqld --user=mysql --datadir=/var/lib/mysql \
# # # 	--socket=/run/mysqld/mysqld.sock --pid-file=/run/mysqld/mysqld.pid &

# # # # MariaDB가 완전히 시작될 때까지 대기
# # # echo "Waiting for MariaDB to start..."
# # # while ! mysqladmin ping --silent; do
# # # 	echo -n "."; sleep 1
# # # done

# # # echo "MariaDB is up and running!"

# # # 초기화 SQL 명령 실행
# # mysql -u root <<EOF
# # ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# # CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# # CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# # GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# # FLUSH PRIVILEGES;
# # EOF

# # # echo debug 1

# # # # MariaDB가 종료되기를 기다림
# # # killall mysqld
# # # sleep 5


# # # # MariaDB 데몬을 포그라운드에서 실행
# # # echo "Starting MariaDB in foreground..."
# # # wait
# # # exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0

# service mariadb start

# # # 초기화 SQL 명령 실행
# # mysql -u root <<EOF
# # ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# # CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# # CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# # GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# # FLUSH PRIVILEGES;
# # EOF

# # 초기화 SQL 명령 실행
# # mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
# mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
# mysql -e "FLUSH PRIVILEGES;"

# service mariadb stop

# exec '$@'

# !/bin/bash
service mariadb start

# 초기화 SQL 실행
echo "Running initialization SQL..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

service mariadb stop

# MariaDB 데몬 포그라운드 실행
echo "Starting MariaDB in foreground..."
exec $@