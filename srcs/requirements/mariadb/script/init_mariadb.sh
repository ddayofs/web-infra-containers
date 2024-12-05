# #!/bin/bash

# # 환경 변수 설정
# MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
# MYSQL_DATABASE=${MYSQL_DATABASE:-database}
# MYSQL_USER=${MYSQL_USER:-user}
# MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# # MariaDB 서비스 시작
# service mariadb start

# # 데이터베이스 및 유저 생성
# mysql -u root <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF

# # # 데이터베이스 및 유저 생성
# # mysql -u root <<EOF
# # ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
# # CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
# # CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
# # GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
# # FLUSH PRIVILEGES;
# # EOF

# # MariaDB 실행
# exec "$@"

#!/bin/bash

# 환경 변수 설정
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
MYSQL_DATABASE=${MYSQL_DATABASE:-database}
MYSQL_USER=${MYSQL_USER:-user}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# # MariaDB 데몬을 백그라운드에서 시작
# mysqld_safe &

# # MariaDB가 완전히 시작될 때까지 대기
# while ! mysqladmin ping --silent; do
#     echo "Waiting for MariaDB to start..."
#     sleep 1
# done

# # 초기화 SQL 명령 실행
# mysqld -u root <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF

# MariaDB 데몬을 포그라운드로 실행
exec "$@"
