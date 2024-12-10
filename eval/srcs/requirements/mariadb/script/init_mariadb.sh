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

echo "DB Initialized"
service mariadb stop

# MariaDB 데몬 포그라운드 실행
echo "Starting MariaDB in foreground..."
exec $@