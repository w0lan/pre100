# Colors
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

.PHONY: help
help: ## Displays available commands
	@echo "${GREEN}Available commands:${NC}"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${YELLOW}%-15s${NC} %s\n", $$1, $$2}'

.PHONY: build
build: ## Builds Docker containers
	docker compose build

.PHONY: up
up: ## Starts Docker containers
	docker compose up -d

.PHONY: down
down: ## Stops Docker containers
	docker compose down

.PHONY: restart
restart: ## Restarts Docker containers
	docker compose restart

.PHONY: clean
clean: ## Removes containers and volumes
	docker compose down -v --remove-orphans

.PHONY: shell
shell: ## Opens shell in Prestashop (PHP) container
	docker compose exec prestashop bash

# --- PrestaShop Specific Commands ---

.PHONY: composer-install
composer-install: ## Installs Composer dependencies inside the container
	docker compose exec -u app prestashop composer install

.PHONY: ps-assets
ps-assets: ## Builds PrestaShop frontend assets inside the container
	docker compose exec -u app prestashop ./tools/assets/build.sh

.PHONY: ps-cache-clear
ps-cache-clear: ## Clears PrestaShop cache inside the container
	docker compose exec -u app prestashop ./bin/console cache:clear --no-warmup

.PHONY: ps-cs-fixer
ps-cs-fixer: ## Runs PHP-CS-Fixer inside the container
	docker compose exec -u app prestashop ./vendor/bin/php-cs-fixer fix

.PHONY: ps-phpstan
ps-phpstan: ## Runs PHPStan inside the container
	docker compose exec -u app prestashop ./vendor/bin/phpstan analyse -c phpstan.neon.dist

# --- Installation Flow ---

.PHONY: install
install: ## Build and start containers (run composer-install and ps-assets manually after)
	make clean
	make build
	make up
