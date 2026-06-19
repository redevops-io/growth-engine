.PHONY: help install run test lint clean build down

# ─── Variables ────────────────────────────────────────────────────────────────
DOCKER_COMPOSE  ?= docker compose
PROJECT_NAME    ?= growth-engine
PYTHON          ?= python3
PIP             ?= pip3

# ─── Help ──────────────────────────────────────────────────────────────────────
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── Install ───────────────────────────────────────────────────────────────────
install: ## Install project dependencies
	$(PIP) install -r requirements.txt

install-dev: ## Install development dependencies
	$(PIP) install -r requirements-dev.txt

# ─── Run ───────────────────────────────────────────────────────────────────────
run: ## Run the application
	$(DOCKER_COMPOSE) up --build -d

run-dev: ## Run the application in development mode
	$(DOCKER_COMPOSE) up --build

run-local: ## Run the application locally (without Docker)
	$(PYTHON) app.py

# ─── Test ──────────────────────────────────────────────────────────────────────
test: ## Run tests
	$(DOCKER_COMPOSE) run --rm app $(PYTHON) -m pytest tests/

test-local: ## Run tests locally (without Docker)
	$(PYTHON) -m pytest tests/ -v

test-coverage: ## Run tests with coverage report
	$(PYTHON) -m pytest tests/ --cov=. --cov-report=term-missing

# ─── Lint ──────────────────────────────────────────────────────────────────────
lint: ## Run all linters
	$(DOCKER_COMPOSE) run --rm app $(PYTHON) -m flake8 .

lint-local: ## Run linters locally (without Docker)
	$(PYTHON) -m flake8 .

lint-black: ## Check code formatting with Black
	$(PYTHON) -m black --check .

lint-isort: ## Check import ordering with isort
	$(PYTHON) -m isort --check-only .

format: ## Auto-format code with Black and isort
	$(PYTHON) -m black .
	$(PYTHON) -m isort .

# ─── Build ─────────────────────────────────────────────────────────────────────
build: ## Build Docker images
	$(DOCKER_COMPOSE) build

# ─── Clean ─────────────────────────────────────────────────────────────────────
clean: ## Remove build artifacts, caches, and Docker resources
	rm -rf __pycache__/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf *.egg-info/
	rm -rf dist/
	rm -rf build/
	rm -rf .mypy_cache/
	rm -rf .ruff_cache/
	find . -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name '*.pyc' -delete

clean-docker: ## Remove Docker containers, networks, and volumes
	$(DOCKER_COMPOSE) down -v --remove-orphans

clean-all: clean clean-docker ## Remove everything (artifacts + Docker resources)

# ─── Docker Compose lifecycle ──────────────────────────────────────────────────
up: ## Start services in detached mode
	$(DOCKER_COMPOSE) up -d

down: ## Stop and remove containers
	$(DOCKER_COMPOSE) down

logs: ## Tail logs of running services
	$(DOCKER_COMPOSE) logs -f

restart: down up ## Restart all services

# ─── Shell ─────────────────────────────────────────────────────────────────────
shell: ## Open a shell inside the app container
	$(DOCKER_COMPOSE) exec app /bin/bash

shell-local: ## Open a Python shell locally
	$(PYTHON)