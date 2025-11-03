# Temporary vs Permanent Database Objects

## Temporary Objects

What they are: Database objects that exist only for the current session/connection.

Examples:

```sql
CREATE TEMPORARY TABLE temp_sales (...) -- Auto-deleted when session ends
CREATE TEMPORARY VIEW temp_customers (...) -- Auto-deleted when session ends
```

### Use Cases:

- Intermediate calculations in complex queries
- Session-specific data processing
- Temporary reporting or analysis
- Testing queries before making permanent objects

## Permanent Objects

What they are: Database objects that persist until explicitly dropped.

Examples:

```sql
CREATE TABLE sales (...) -- Stays until DROP TABLE
CREATE VIEW customers (...) -- Stays until DROP VIEW
```

### Use Cases:

- Business logic used by multiple applications
- Data security (row/column level security)
- Frequently used complex queries
- Shared data structures across users

## Key Difference

Temporary: Session-only, auto-cleaned up, isolated per user
Permanent: Persistent until manually removed, shared across users

Choose temporary for one-time analysis, permanent for reusable business logic.
