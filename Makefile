# ==========================================
# Variables & Constants
# ==========================================
DOCKER_COMPOSE = docker-compose
APP_URL        = http://192.168.49.2:30007
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
# FIXED: Changed from 'docker-compose' to use the variable defined above
logs:
	$(DOCKER_COMPOSE) logs

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

# ... (rest of your file stays the same)
