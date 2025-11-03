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

# UUID

## UUID vs Sequential ID - Quick Guide

### UUID Benefits:

```sql
-- UUID Example (16 bytes)
id = '550e8400-e29b-41d4-a716-446655440000'

-- Sequential ID Example (4 bytes)
id = 1
```

### Key Advantages:

🌍 Distributed Systems - Unique across all databases
🔒 Security - Can't guess next ID: /users/123 → /users/550e8400...
📱 Offline First - Generate IDs on client before sync
🔄 Safe Merging - No ID conflicts when combining databases

### Use Cases:

- Microservices architecture
- Mobile apps (offline data creation)
- Multi-tenant SaaS applications
- Systems that need database sharding

### When to Avoid:

- Simple web apps (blog, CMS)
- High-performance requirements
- Limited storage space
- Need simple debugging: WHERE id = 5
  Best Practice:
  ```sql
  -- Always add created_at for sorting
  CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid(),
  created_at TIMESTAMP DEFAULT NOW()
  );
  ```
  Choose UUIDs for distributed systems, sequential IDs for simple apps.
