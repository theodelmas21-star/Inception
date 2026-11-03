NAME = inception

SRCS_DIR = ./srcs
DOCKER_COMPOSE = $(SRCS_DIR)/docker-compose.yml
ENV_FILE = $(SRCS_DIR)/.env

GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

all: up

up:
	@echo "$(GREEN)Création des dossiers pour les volumes s'ils n'existent pas...$(RESET)"
	@mkdir -p /home/tdelmas2/data/mariadb
	@mkdir -p /home/tdelmas2/data/wordpress
	@echo "$(GREEN)Lancement de l'infrastructure Inception...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE) up -d --build

down:
	@echo "$(RED)Arrêt des conteneurs...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE) down

stop:
	@echo "$(RED)Interruption des conteneurs...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE) stop

start:
	@echo "$(GREEN)Redémarrage des conteneurs existants...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE) start

status:
	@docker compose -f $(DOCKER_COMPOSE) ps

logs:
	@docker compose -f $(DOCKER_COMPOSE) logs -f

clean: down
	@echo "$(RED)Suppression des conteneurs et des réseaux...$(RESET)"
	@docker system prune -a --force

fclean: clean
	@echo "$(RED)Nettoyage complet : suppression des volumes et des données sur le disque...$(RESET)"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/tdelmas2/data/mariadb/*
	@sudo rm -rf /home/tdelmas2/data/wordpress/*

re: fclean all

.PHONY: all up down stop start status logs clean fclean re
