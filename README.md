# sql-jornada-de-dados

Repository to store the files from SQL course from Jornada de Dados.

## Setup

Run the command below to set up the complete environment. This will:

```bash
make up
```

- Create Docker containers for PostgreSQL server and pgAdmin
- Execute the `northwind.sql` script to set up the database schema
- Create an admin user with password `admin`
- Place both services in the same network with individual volumes
- Configure pgAdmin to depend on PostgreSQL server
- Set pgAdmin login email to `admin@admin.com`

After running, access pgAdmin at `http://localhost:8080` using email `admin@admin.com` and password `admin`.
