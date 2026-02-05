WORKDIR = ./srcs
VOLUMEDIR = /home/vsanin/data

RESET=\033[0m
YELLOW=\033[33m
BRED=\033[91m
BGREEN=\033[92m

all: up

up:
	@echo "$(BGREEN)Creating directories for docker volumes in /home/vsanin/data (if don't exist)... $(YELLOW)['mkdir -p /home/vsanin/data/<volume>']$(RESET)"
	@mkdir -p $(VOLUMEDIR)/db-volume $(VOLUMEDIR)/wp-volume
	@echo "$(BGREEN)Building images and starting containers (detached)... $(YELLOW)['docker compose up -d --build']$(RESET)"
	@cd $(WORKDIR) && docker compose up -d --build

down:
	@echo "$(BRED)Removing containers... $(YELLOW)['docker compose down']$(RESET)"
	@cd $(WORKDIR) && docker compose down

build:
	@echo "$(BGREEN)Building all images... $(YELLOW)['docker compose build']$(RESET)"
	@cd $(WORKDIR) && docker compose build

lsall:
	@echo "$(BGREEN)Containers: $(YELLOW)['docker compose ps']$(RESET)"
	@cd $(WORKDIR) && docker compose ps -a
	@echo "$(BGREEN)Images: $(YELLOW)['docker image ls']$(RESET)"
	@cd $(WORKDIR) && docker image ls
	@echo "$(BGREEN)Volumes: $(YELLOW)['docker volume ls']$(RESET)"
	@cd $(WORKDIR) && docker volume ls

logs:
	@echo "$(BGREEN)Logs: $(YELLOW)['docker compose logs']$(RESET)"
	@cd $(WORKDIR) && docker compose logs

clean:
	@echo "$(BRED)Removing containers and deleting compose volumes... $(YELLOW)['docker compose down -v --rmi local']$(RESET)"
	@cd $(WORKDIR) && docker compose down -v --rmi local

fclean: clean
	@echo "$(BRED)Deleting local volumes... $(YELLOW)['rm -rf /home/vsanin/data']$(RESET)"
	@sudo rm -rf $(VOLUMEDIR)

re:
	@echo "$(YELLOW)Rebuilding and restarting...$(RESET)"
	$(MAKE) fclean
	$(MAKE) up

.PHONY: all up down build ps clean fclean re