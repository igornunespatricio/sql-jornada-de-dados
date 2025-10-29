PROJECT_NAME := sql-jornada-de-dados

up:
	@echo "Starting $(PROJECT_NAME) containers"
	docker-compose -p $(PROJECT_NAME) up -d

down:
	@echo "Stopping $(PROJECT_NAME) containers"
	docker-compose -p $(PROJECT_NAME) down