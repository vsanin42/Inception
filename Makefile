WORKDIR = ./srcs
VOLUMEDIR = /home/vsanin/data

RESET=\033[0m
RED=\033[31m
GREEN=\033[32m
YELLOW=\033[33m
MAGENTA=\033[35m
ORANGE=\033[38;5;208m
BRED=\033[91m
BGREEN=\033[92m
BBLUE=\033[94m
BMAGENTA=\033[95m
BCYAN=\033[96m
BOLD=\033[1m

all: up

up:
	@echo "$(BGREEN)Creating directories for docker volumes in /home/vsanin/data...$(RESET)"
	@mkdir -p $(VOLUMEDIR)/db-volume && mkdir -p $(VOLUMEDIR)/wp-volume
	@echo "$(BGREEN)Running 'docker compose up'...$(RESET)"
	@cd $(WORKDIR) && docker compose up -d --build

down:
	@echo "$(BRED)Running 'docker compose down'...$(RESET)"
	@cd $(WORKDIR) && docker compose down

# todo rebuild? condition for creating dirs?

clean: down

fclean: clean
	@echo "$(BRED)Deleting images...$(RESET)"
	@cd $(WORKDIR) && docker rmi -f $$(docker images -aq)
	@echo "$(BRED)Deleting volumes...$(RESET)"
	@cd $(WORKDIR) && docker volume rm db-volume && docker volume rm srcs_wp-volume
	@cd $(VOLUMEDIR) && rm -rf .

re: fclean all

.PHONY: all up down clean fclean re