# Variables
COMPOSE=docker compose

.PHONY: build up down logs test clean

# Produce a clean, efficient build
build:
    docker compose build --no-cache

# Run the application via Docker Compose
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Follow logs for debugging
logs:
	docker compose logs -f

# Functional test: Checks if index and php are reachable
test:
	@echo "Checking application health..."
	@curl -f http://localhost:8081/index.html && echo "\n[SUCCESS] Index page is live."
	@curl -f http://localhost:8081/info.php && echo "\n[SUCCESS] PHP is executing."
	./scripts/test_smoke.sh
	./scripts/healthcheck.sh

# Cleanup images and volumes
clean:
	$(COMPOSE) down -v
	docker system prune -f

backup:
	./scripts/backup_site.sh
	./scripts/backup_db.sh	