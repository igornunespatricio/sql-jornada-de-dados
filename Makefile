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

test-dbt:
	@echo "Running dbt tests"
	cd northwind_dbt/northwind && poetry run dbt test

test-dbt-staging:
	@echo "Running dbt tests on staging models only"
	cd northwind_dbt/northwind && poetry run dbt test --select staging

test-dbt-marts:
	@echo "Running dbt tests on marts models only"
	cd northwind_dbt/northwind && poetry run dbt test --select marts

test-dbt-source:
	@echo "Running dbt tests on sources only"
	cd northwind_dbt/northwind && poetry run dbt test --select source:*

test-dbt-fail-fast:
	@echo "Running dbt tests with fail-fast option"
	cd northwind_dbt/northwind && poetry run dbt test --fail-fast

run-test-dbt: run-dbt test-dbt
	@echo "Completed dbt run and test"

all-dbt: seed-dbt run-dbt test-dbt
	@echo "Completed dbt seed, run and test"

docs-generate:
	@echo "Generating dbt documentation"
	cd northwind_dbt/northwind && poetry run dbt docs generate

docs-serve:
	@echo "Serving dbt documentation"
	cd northwind_dbt/northwind && poetry run dbt docs serve --port 8081

debug-dbt:
	@echo "Running dbt debug"
	cd northwind_dbt/northwind && poetry run dbt debug