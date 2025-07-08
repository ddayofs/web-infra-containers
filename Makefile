DIR        := /home/donglee2           # 우분투 홈
HOSTS_FILE := /etc/hosts
DOMAIN     := donglee2.42.fr
IP         := 127.0.0.1

# ─── OS 별 유틸 호환 설정 ──────────────────────────────
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)               # Ubuntu / WSL / 기타 리눅스
    STAT_PERM  := stat -c "%a"
    COMPOSE    := docker compose      # ← V2
else                                   # macOS (BSD 유틸)
    STAT_PERM  := stat -f "%a"
    COMPOSE    := docker-compose
endif

.PHONY: all re clean fclean help

# ─── all ───────────────────────────────────────────────
all: add
	# mariadb_data
	@if [ ! -d "$(DIR)/data/mariadb" ]; then mkdir -p $(DIR)/data/mariadb; fi
	@if [ $$($(STAT_PERM) $(DIR)/data/mariadb) -ne 755 ]; then chmod -R 755 $(DIR)/data/mariadb; fi

	# wordpress_data
	@if [ ! -d "$(DIR)/data/wordpress" ]; then mkdir -p $(DIR)/data/wordpress; fi
	@if [ $$($(STAT_PERM) $(DIR)/data/wordpress) -ne 755 ]; then chmod -R 755 $(DIR)/data/wordpress; fi

	# docker-compose up
	$(COMPOSE) -f ./srcs/docker-compose.yml up -d --build

# ─── hosts 파일에 도메인 추가 ──────────────────────────
add:
	@if ! grep -q "$(DOMAIN)" $(HOSTS_FILE); then \
	    echo "$(IP) $(DOMAIN)" | sudo tee -a $(HOSTS_FILE) >/dev/null; \
	    echo "Added $(DOMAIN) to $(HOSTS_FILE)."; \
	else \
	    echo "$(DOMAIN) already exists in $(HOSTS_FILE)."; \
	fi

# ─── 재생성 / 정리 타깃 ────────────────────────────────
re: fclean all

clean:
	-$(COMPOSE) -f ./srcs/docker-compose.yml down || true

fclean: clean
	@sudo sed -i.bak "/$(DOMAIN)/d" $(HOSTS_FILE)
	@echo "Removed $(DOMAIN) from $(HOSTS_FILE) (backup: $(HOSTS_FILE).bak)"
	sudo rm -rf $(DIR)/data/mariadb/* $(DIR)/data/wordpress/*
	docker volume ls -q | xargs -r docker volume rm
	docker images  -q | xargs -r docker rmi -f

help:
	@echo "Targets: all | re | clean | fclean"
