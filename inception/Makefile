NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = $(HOME)/data

all: up

build:
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	docker compose -f $(COMPOSE_FILE) build

up:
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

start:
	docker compose -f $(COMPOSE_FILE) start

stop:
	docker compose -f $(COMPOSE_FILE) stop

restart:
	docker compose -f $(COMPOSE_FILE) restart

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) ps

clean:
	docker compose -f $(COMPOSE_FILE) down --rmi local -v

fclean: clean
	docker compose -f $(COMPOSE_FILE) down --rmi all -v --remove-orphans
	docker system prune -af --volumes
	sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress

re: fclean all

.PHONY: all build up down start stop restart logs ps clean fclean re