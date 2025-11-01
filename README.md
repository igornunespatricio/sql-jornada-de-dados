# SQL Jornada de Dados - Northwind Database Analytics

A complete Docker-based PostgreSQL analytics environment with automated view management for the Northwind database. This project provides a robust containerized setup for data analysis with automatic view synchronization and monitoring using Docker Compose.

## ✨ Features

| Feature                          | Description                                               |
| -------------------------------- | --------------------------------------------------------- |
| 🐘 **PostgreSQL 15**             | Full Northwind database pre-loaded and ready for analysis |
| 🖥️ **PgAdmin 4 Web Interface**   | Complete database management through web browser          |
| 🔄 **Automated View Management** | Views automatically synchronized every minute via cron    |
| ❤️ **Health Monitoring**         | Built-in health checks ensure reliable service startup    |
| 💾 **Persistent Data Storage**   | Database data persists safely across container restarts   |
| ⚡ **Makefile Automation**       | Simple commands for effortless project management         |
| 🔒 **Isolated Docker Network**   | Secure container communication in dedicated network       |
| 🚀 **Self-Healing Views**        | Automatic view recreation on schema changes               |

## Quick Start

### Prerequisites

- 🐳 [Docker](https://www.docker.com/get-started)
- 🐙 [Docker Compose](https://docs.docker.com/compose/install/)
- 🔧 [Make](https://www.gnu.org/software/make/) (optional, but recommended)

## 🚀 Getting Started

### 🛠️ Project Setup

| Step | Action                 | Result                                      |
| ---- | ---------------------- | ------------------------------------------- |
| 1    | **Clone & Setup**      | Download and prepare the project            |
| 2    | **Run `make up`**      | Start all Docker services automatically     |
| 3    | **Auto-Configuration** | Script permissions set, containers launched |

### 🌐 Access Services

| Service                   | Access                                                                      | Credentials                          |
| ------------------------- | --------------------------------------------------------------------------- | ------------------------------------ |
| **PgAdmin Web Interface** | 🌍 http://localhost:8080                                                    | 📧 admin@admin.com<br>🔑 admin       |
| **PostgreSQL Database**   | 🗄️ localhost:5432<br>🔗 `postgresql://admin:admin@localhost:5432/northwind` | 🗃️ northwind<br>👤 admin<br>🔑 admin |

## ⚡ Makefile Commands

**Effortless project management with simple commands:**

- 🚀 `make up` - Launch all services in background
- 🛑 `make down` - Gracefully stop all running services
- 🧹 `make clean` - Complete reset (removes all data and containers)
- 🔧 `make setup-scripts` - Prepare scripts for execution

## 📊 Database Views

**Automatically maintained analytical views:**

- 📈 **Monthly Revenue** - Track revenue trends with month-over-month analysis and YTD calculations
- 👥 **Customer Revenue** - Rank customers by revenue performance
- 🎯 **Customer Segmentation** - Group customers into revenue quintiles for targeted analysis
- 🏆 **Top Products** - Identify best-performing products
- 📅 **Annual Revenue** - Year-over-year revenue trends and patterns
- 🇬🇧 **UK High-Value Customers** - Focus on premium UK customer segment

_All views automatically refresh every minute to ensure data consistency_

## 🏗️ System Architecture

### 🐘 **PostgreSQL Service**

- **Database Initialization** - Northwind database created on first launch
- **Data Persistence** - Docker volumes ensure data survives container restarts
- **Health Monitoring** - Built-in health checks guarantee service reliability

### 🔄 **View Initializer Service**

- **Lightweight Design** - Alpine Linux container for minimal resource usage
- **Auto-provisioning** - Automatically installs PostgreSQL client tools
- **Continuous Sync** - Runs view synchronization every 60 seconds
- **Self-contained** - Zero external dependencies required

### 🖥️ **PgAdmin Service**

- **Web-based Management** - Full database administration through browser
- **Pre-configured Access** - Automatic connection to PostgreSQL service
- **Persistent Settings** - Configuration survives container updates
- **User-friendly Interface** - Intuitive GUI for database operations

## 📈 Data Flow Pipeline

1. **🚀 Initialization** - Northwind schema and sample data loaded on first run
2. **🔍 Readiness Detection** - View initializer waits for PostgreSQL to be fully ready
3. **📊 View Creation** - All analytical views created using safe replacement syntax
4. **🔄 Continuous Monitoring** - Cron job ensures views stay synchronized
5. **⚡ Live Updates** - Schema changes automatically propagate to all views
