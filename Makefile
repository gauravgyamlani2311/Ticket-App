# Variables
COMPOSE=docker-compose

.PHONY: build up down logs test clean

# Produce a clean, efficient build
build:
	$(COMPOSE) build --no-cache

# Run the application via Docker Compose
up:
	$(COMPOSE) up -d

# Stop all services
down:
	$(COMPOSE) down

# Follow logs for debugging
logs:
	$(COMPOSE) logs -f

# Functional test: Checks if index and php are reachable
test:
	@echo "Checking application health..."
	@curl -f http://localhost:8081/index.html && echo "\n[SUCCESS] Index page is live."
	@curl -f http://localhost:8081/info.php && echo "\n[SUCCESS] PHP is executing."

# Cleanup images and volumes
clean:
	$(COMPOSE) down -v
	docker system prune -f

# test cases
test:
	./scripts/test_smoke.sh
	./scripts/healthcheck.sh

backup:
	./scripts/backup_site.sh
	./scripts/backup_db.sh	