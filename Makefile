# ==========================================
# Variables & Constants
# ==========================================
DOCKER_COMPOSE = docker compose
APP_URL        = http://localhost:8081
SCRIPTS_DIR    = ./scripts

# List of targets that are not actual files
.PHONY: build up down logs test clean backup help

# ==========================================
# Core Workflow
# ==========================================

# 1. Build the stack from scratch without using cache
build:
	$(DOCKER_COMPOSE) build --no-cache

# 2. Launch the application in detached (background) mode
up:
	$(DOCKER_COMPOSE) up -d

# 3. Stop and remove all running containers
down:
	$(DOCKER_COMPOSE) down

# 4. Follow application and database logs
logs:
	$(DOCKER_COMPOSE) logs -f

# ==========================================
# Testing & Validation
# ==========================================

# Run automated health checks and smoke tests
test:
	@echo "--- [1/3] Checking HTTP Endpoint ---"
	@curl -f $(APP_URL)/index.html && echo "\n[OK] Index page reachable."
	@curl -f $(APP_URL)/info.php && echo "\n[OK] PHP engine functional."
	@echo "\n--- [2/3] Executing Smoke Tests ---"
	@chmod +x $(SCRIPTS_DIR)/test_smoke.sh && $(SCRIPTS_DIR)/test_smoke.sh
	@echo "\n--- [3/3] Executing Deep Healthcheck ---"
	@chmod +x $(SCRIPTS_DIR)/healthcheck.sh && $(SCRIPTS_DIR)/healthcheck.sh

# ==========================================
# Maintenance & Backups
# ==========================================

# Execute site and database backup scripts
backup:
	@echo "Starting backup process..."
	@chmod +x $(SCRIPTS_DIR)/backup_site.sh && $(SCRIPTS_DIR)/backup_site.sh
	@chmod +x $(SCRIPTS_DIR)/backup_db.sh && $(SCRIPTS_DIR)/backup_db.sh

# Deep clean: remove containers, volumes, and dangling images
clean:
	$(DOCKER_COMPOSE) down -v
	docker system prune -f

# ==========================================
# Help Documentation
# ==========================================
help:
	@echo "Available commands:"
	@echo "  make build  - Build Docker images"
	@echo "  make up     - Start the application"
	@echo "  make test   - Run all connectivity tests"
	@echo "  make clean  - Wipe environment and cached data"