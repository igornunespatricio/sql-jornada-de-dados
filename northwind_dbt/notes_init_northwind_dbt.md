# Set up dbt project from scratch

1. command to start poetry:

```bash
poetry install
```

2. create profiles.yml in ~/.dbt

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

7. run debug to test connection to database, everything should look good

```bash
poetry run dbt debug
```

8. the models folder comes with examples that can be deleted, they won't impact the project

```bash
rm -rf models/example/
```

# Directories

## seeds directory

if you have csv files and want to add to your database as new tables or new rows, you just drop them into the seeds directory.

Sample of region.csv added to seeds directory

| region_id | region_description |
| --------- | ------------------ |
| 1         | Eastern            |
| 2         | Western            |
| 3         | Northern           |
| 4         | Southern           |
| 5         | New Region         |

sample of new_table_seed.csv

| id  | col1 | col2 |
| --- | ---- | ---- |
| 1   | a    | b    |
| 2   | c    | d    |
| 3   | e    | f    |
| 4   | g    | h    |
| 5   | i    | j    |
| 6   | k    | l    |
| 7   | m    | n    |
| 8   | o    | p    |
| 9   | q    | r    |

Run command to load data into database. This command will create the table region. If the table already exists, it will be dropped and recreated. The --full-refresh option will drop the table if it already exists.

```bash
poetry run dbt seed --full-refresh
```

## models

This is where you write your models. Anything in your models directory will be a table or a view.

This link [Best Practice to structure models](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview) details the best practices to structure models according to dbt. Similar to medallion architecture.
