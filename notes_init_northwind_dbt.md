1. command to start poetry:

```bash
poetry install
```

3. create profiles.yml in ~/.dbt

The command below creates the .dbt directory, creates the profiles.yml in it and puts the contents of the YAML file above into the file.

```bash
mkdir -p ~/.dbt && cat > ~/.dbt/profiles.yml << 'EOF'
northwind:
  outputs:
    dev:
      dbname: northwind
      host: localhost
      pass: admin
      port: 5432
      schema: dev
      threads: 1
      type: postgres
      user: admin
  target: dev
EOF
```

YAML file will be something like this:

```yml
northwind:
  outputs:
    dev:
      dbname: northwind
      host: localhost
      pass: admin
      port: 5432
      schema: dev
      threads: 1
      type: postgres
      user: admin
  target: dev
```

4. create and enter dbt project directory

```bash
mkdir northwind_dbt
cd northwind_dbt
```

5. init dbt project

```bash
poetry run dbt init --skip-profile-setup northwind
```

6. enter northwind

```bash
cd northwind
```

7. ruun debug to test connection to database, everything should look good

```bash
poetry run dbt debug
```
