PROJECT_NAME := sql-jornada-de-dados

setup-scripts:
	@echo "Setting script permissions"
	chmod +x scripts/*.sh

up: setup-scripts
	@echo "Starting $(PROJECT_NAME) containers"
	docker-compose -p $(PROJECT_NAME) up -d

down:
	@echo "Stopping $(PROJECT_NAME) containers"
	docker-compose -p $(PROJECT_NAME) down

clean:
	@echo "Removing all containers, volumes, and networks for $(PROJECT_NAME)"
	docker-compose -p $(PROJECT_NAME) down --volumes --remove-orphans

seed-dbt:
	@echo "Seeding dbt"
	cd northwind_dbt/northwind && poetry run dbt seed

run-dbt:
	@echo "Running dbt models"
	cd northwind_dbt/northwind && poetry run dbt run

all-dbt: seed-dbt run-dbt
	@echo "Completed dbt seed and run"