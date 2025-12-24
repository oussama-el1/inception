NAME = inception
DOCKER_COMPOSE = docker compose -f ./srcs/docker-compose.yml
DATA_PATH = /home/oel-hadr/data

all: up

up:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down

clean:
	@$(DOCKER_COMPOSE) down -v

fclean: clean
	@docker system prune -af

re: fclean up

.PHONY: all up down clean fclean re