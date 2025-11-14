# SQL Jornada de Dados - Northwind Database Analytics

A complete Docker-based PostgreSQL environment for data analytics with the classic Northwind database. This project provides a robust, containerized setup with automated database initialization and view management.

## ✨ Features

- **🐘 PostgreSQL 15** - Northwind database pre-loaded and ready for analysis
- **🖥️ PgAdmin 4 Web Interface** - Complete database management through web browser
- **🔄 Automated Database Initialization** - Multiple databases created automatically
- **📊 Automated View Management** - Views synchronized via cron job
- **❤️ Health Monitoring** - Built-in health checks ensure reliable service startup
- **💾 Persistent Data Storage** - Database data persists across container restarts
- **⚡ Makefile Automation** - Simple commands for effortless project management
- **🔒 Isolated Docker Network** - Secure container communication
- **📊 dbt Analytics** - Complete data transformation pipeline with staging and mart models
- **🔍 Data Documentation** - Automated lineage and documentation with `dbt docs`
- **✅ Data Quality Testing** - Built-in testing for data validation
- **🔄 Modern Data Stack** - Full ELT workflow with transformation layer

## 🚀 Quick Start

### Prerequisites

- 🐳 [Docker](https://www.docker.com/get-started)
- 🐙 [Docker Compose](https://docs.docker.com/compose/install/)
- 🔧 [Make](https://www.gnu.org/software/make/) (optional, but recommended)

### Installation & Setup

1. **Start the services**
   The project will automatically set up script permissions and launch all Docker services

```bash
git clone <your-repo-url>
cd <project-directory>

make up
```

2. **Access the services**
   - **PgAdmin**: http://localhost:8080
     - Email: `admin@admin.com`
     - Password: `admin`
   - **PostgreSQL**: `localhost:5432`
     - Connection string: `postgresql://admin:admin@localhost:5432/northwind`

## 🛠️ Project Architecture

### Services Overview

Your Docker Compose setup includes four main services:

#### 1. **PostgreSQL Database** (`postgres:15`)

- Hosts the main `northwind` database
- Pre-configured with health checks
- Data persistence through Docker volumes
- Automatic initialization scripts execution

#### 2. **View Initializer** (`alpine:latest`)

- Automatically creates and maintains database views
- Runs every minute via cron job
- Executes all SQL files from the `/views` directory
- Waits for PostgreSQL to be healthy before starting

#### 3. **Database Initializer** (`alpine:latest`)

- Creates and initializes multiple databases:
  - `itau`
  - `trigger`
  - `acid`
  - `queryorder`
  - `index_db`
  - `partition_db`
- Executes corresponding SQL initialization scripts
- Runs once after PostgreSQL is healthy

#### 4. **PgAdmin** (`dpage/pgadmin4`)

- Web-based database administration tool
- Pre-configured with server connections
- Accessible at http://localhost:8080

## 📁 Project Structure

The project is organized with clear separation of concerns:

- Main service configuration
- Automation commands
- Database initialization scripts
- View management with cron support
- SQL view definitions
- PgAdmin server configuration

## ⚡ Available Commands

The project includes automated commands for:

- Preparing scripts for execution
- Starting all Docker services
- Stopping running services
- Complete system reset

```bash
make setup-scripts    # Prepare scripts for execution
make up              # Start all Docker services
make down            # Stop running services
make clean           # Complete system reset
```

## 🎯 dbt Analytics Commands

```bash
make run-dbt              # Run all dbt models
make test-dbt             # Run data quality tests
make docs-serve           # Serve data documentation
make deps-dbt             # Install dbt dependencies
```

## 🔄 Automation Details

### Database Initialization

The system automatically:

- Waits for PostgreSQL to be ready
- Creates specified databases
- Executes corresponding SQL initialization scripts
- Handles multiple databases in sequence

### View Management

The view system:

- Runs in cron mode (every minute)
- Executes all SQL files in the views directory
- Ensures views stay synchronized with schema changes
- Automatically installs required dependencies

## 🌐 Access Points

| Service            | URL                   | Credentials                                                 |
| ------------------ | --------------------- | ----------------------------------------------------------- |
| **PgAdmin Web UI** | http://localhost:8080 | Email: `admin@admin.com`<br>Password: `admin`               |
| **PostgreSQL**     | `localhost:5432`      | User: `admin`<br>Password: `admin`<br>Database: `northwind` |

## 🗃️ Available Databases

- **northwind** - Primary database with sample data
- **itau** - Additional database for specific use cases
- **trigger** - Database for trigger-related functionality
- **acid** - Database for ACID compliance testing
- **queryorder** - Database for query optimization
- **index_db** - Database for index management
- **partition_db** - Database for partitioning examples

## 🔧 Troubleshooting

If you encounter issues:

```bash
docker-compose ps                          # Check service status
docker-compose logs [service-name]         # View service logs
make clean && make up                      # Full reset
make setup-scripts                         # Verify script permissions
```

## 📝 Notes

- All database data persists in Docker volumes
- The view initializer runs continuously to maintain view consistency
- Health checks ensure proper service startup order
- The project uses a dedicated Docker network for isolation

---

**Ready to explore your Northwind database analytics environment!** 🚀

## 🚀 Possible Enhancements

This project could be extended with:

- **More dbt mart models** for advanced business analytics
- **dbt snapshots** to track historical dimension changes
- **CI/CD pipeline** for automated testing and deployment
- **BI dashboard integrations** using the mart tables
- **Incremental models** for better performance with large datasets
- **Custom dbt macros** for reusable business logic
- **Production deployment** with multiple environments
- **Data quality monitoring** with automated alerts
