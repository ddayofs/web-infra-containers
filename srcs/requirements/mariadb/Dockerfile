
# 베이스 이미지로 Debian 사용
FROM debian:bullseye

# dumb-init 설치
RUN apt-get update && \
	apt-get install -y dumb-init mariadb-server mariadb-client vim && \
	apt-get clean

# 스크립트 파일 복사
COPY ./script/init_mariadb.sh /tmp/init_mariadb.sh

# 실행 권한 부여
RUN chmod +x /tmp/init_mariadb.sh

# # MariaDB 포트 노출
# EXPOSE 3306

# ENTRYPOINT를 dumb-init과 init_mariadb.sh로 설정
ENTRYPOINT ["dumb-init", "--", "/tmp/init_mariadb.sh"]
CMD ["mysqld", "--bind-address=0.0.0.0"]

