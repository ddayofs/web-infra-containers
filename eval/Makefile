DIR = /home/donglee2
# DIR=/Users/ldk

HOSTS_FILE=/etc/hosts
DOMAIN=donglee2.42.fr
IP=127.0.0.1

.PHONY: all re clean fclean

# all: 실행 중인 컨테이너가 없으면 컨테이너를 생성하고 실행
# --build :이미지를 새로 빌드하고 실행하는 옵션
all: add
	# mariadb_data 디렉터리 존재 여부 확인 및 생성
	@if [ ! -d "$(DIR)/data/mariadb" ]; then \
		mkdir -p $(DIR)/data/mariadb; \
	fi
	# mariadb_data 디렉터리 권한 확인 및 수정
	@if [ $(shell stat -f "%a" $(DIR)/data/mariadb) -ne 755 ]; then \
		chmod -R 755 $(DIR)/data/mariadb; \
	fi

	# wordpress_data 디렉터리 존재 여부 확인 및 생성
	@if [ ! -d "$(DIR)/data/wordpress" ]; then \
		mkdir -p $(DIR)/data/wordpress; \
	fi
	# wordpress_data 디렉터리 권한 확인 및 수정
	@if [ $(shell stat -f "%a" $(DIR)/data/wordpress) -ne 755 ]; then \
		chmod -R 755 $(DIR)/data/wordpress; \
	fi
	
	# docker-compose로 컨테이너 실행
	docker-compose -f ./srcs/docker-compose.yml up -d --build

add:
	@if ! grep -q "$(DOMAIN)" $(HOSTS_FILE); then \
		echo "$(IP) $(DOMAIN)" | sudo tee -a $(HOSTS_FILE) > /dev/null; \
		echo "Added $(DOMAIN) to $(HOSTS_FILE)."; \
	else \
		echo "$(DOMAIN) already exists in $(HOSTS_FILE)."; \
	fi

# re: 컨테이너를 재생성 (중단 및 삭제 후 다시 생성)
re: fclean
	make all
	
clean:
	docker-compose -f ./srcs/docker-compose.yml down || true



# fclean: 실행 중인 컨테이너, 볼륨, 이미지까지 모두 삭제
fclean: clean
	@sudo sed -i.bak "/$(DOMAIN)/d" $(HOSTS_FILE)
	@echo "Removed $(DOMAIN) from $(HOSTS_FILE). Backup created: $(HOSTS_FILE).bak"
	sudo rm -rf $(DIR)/data/mariadb/*
	sudo rm -rf $(DIR)/data/wordpress/*
	docker volume ls -q | xargs -r docker volume rm
	docker images -qa | xargs -r docker rmi -f

# 도움말
help:
	@echo "Available targets:"
	@echo "  all    : Create and start containers (if not already running)"
	@echo "  re     : Recreate containers (stop, remove, then create again)"
	@echo "  clean  : Stop and remove containers and networks (keep images)"
	@echo "  fclean : Stop and remove everything (containers, networks, volumes, images)"
