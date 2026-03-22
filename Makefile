.DEFAULT_GOAL := help
MANAGE = uv run python manage.py

.PHONY: help install run migrate makemigrations shell test lint lint-fix collectstatic seed build up down

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install all dependencies (dev group)
	uv sync --group dev

run: ## Start the development server
	$(MANAGE) runserver

migrate: ## Apply database migrations
	$(MANAGE) migrate

makemigrations: ## Create new migrations
	$(MANAGE) makemigrations

shell: ## Open Django shell
	$(MANAGE) shell

test: ## Run test suite
	$(MANAGE) test

lint: ## Lint and format code with ruff
	uv run ruff check .
	uv run ruff format --check .

lint-fix: ## Auto-fix lint issues
	uv run ruff check --fix .
	uv run ruff format .

collectstatic: ## Collect static files
	$(MANAGE) collectstatic --noinput

seed: ## Seed the database with demo data
	uv run python scripts/seed_data.py

build: ## Build Docker images
	docker compose build

up: ## Start all Docker services
	docker compose up

down: ## Stop all Docker services
	docker compose down
