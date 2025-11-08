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

# Stored procedures

## What they are:

Pre-written SQL code saved in the database for repeated execution.

## Key Benefits:

- Performance: Pre-compiled for faster execution
- Security: Grant execute rights without direct table access
- Maintenance: Business logic centralized in database
- Efficiency: Reduce network traffic and code duplication

## Typical Uses:

Data validation, complex reports, batch operations, and business logic encapsulation.

## Example

```sql
CREATE PROCEDURE GetCustomerOrderSummary
    @CustomerID INT,
    @StartDate DATE
AS
BEGIN
    SELECT
        c.CustomerName,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.CustomerID = @CustomerID
    AND o.OrderDate >= @StartDate
    GROUP BY c.CustomerName;
END

EXEC GetCustomerOrderSummary @CustomerID = 123, @StartDate = '2024-01-01';
```

# Triggers

## O que são Triggers?

#### 1. O que são Triggers

- **Definição**: Triggers são procedimentos armazenados, que são automaticamente executados ou disparados quando eventos específicos ocorrem em uma tabela ou visão.
- **Funcionamento**: Eles são executados em resposta a eventos como INSERT, UPDATE ou DELETE.

#### 2. Por que usamos Triggers em projetos

- **Automatização de tarefas**: Para realizar ações automáticas que são necessárias após modificações na base de dados, como manutenção de logs ou atualização de tabelas relacionadas.
- **Integridade de dados**: Garantir a consistência e a validação de dados ao aplicar regras de negócio diretamente no banco de dados.

#### 3. Origem e finalidade da criação dos Triggers

- **História**: Os triggers foram criados para oferecer uma maneira de responder automaticamente a eventos de modificação em bancos de dados, permitindo a execução de procedimentos de forma automática e transparente.
- **Problemas resolvidos**: Antes dos triggers, muitas dessas tarefas precisavam ser controladas manualmente no código da aplicação, o que poderia levar a erros e inconsistências.

# ACID

ACID is a set of four key properties that guarantee reliable database transactions:

## A - Atomicity

- **All or nothing**: Entire transaction must complete or fail completely
- **No partial updates**: If any part fails, everything rolls back
- _Example: Bank transfer - both debit AND credit must succeed_

## C - Consistency

- **Data integrity**: Transaction moves database from one valid state to another
- **Rules preserved**: All constraints, triggers, and cascades are maintained
- _Example: Account balance never goes negative_

## I - Isolation

- **Concurrent control**: Multiple transactions don't interfere with each other
- **Serializable**: Appears as if transactions run one after another
- _Example: Two transfers see consistent balances_

### Examples

```sql
-- Transaction 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT balance FROM accounts WHERE id = 1; -- Returns 100

-- Transaction 2 (commits)
UPDATE accounts SET balance = 50 WHERE id = 1;
COMMIT;

-- Back to Transaction 1
SELECT balance FROM accounts WHERE id = 1; -- Returns 50 (CHANGED!)
```

```sql
-- Transaction 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SELECT balance FROM accounts WHERE id = 1; -- Returns 100

-- Transaction 2 (commits)
UPDATE accounts SET balance = 50 WHERE id = 1;
COMMIT;

-- Back to Transaction 1
SELECT balance FROM accounts WHERE id = 1; -- Still returns 100 (SAME!)
```

```sql
-- Session 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
SELECT SUM(balance) FROM accounts WHERE type = 'savings';
-- Returns 5000

-- Session 2 (tries to run concurrently)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
UPDATE accounts SET balance = balance + 1000 WHERE id = 1;
-- This will BLOCK or cause serialization failure

-- Back to Session 1
INSERT INTO audit_log (total_savings) VALUES (5000);
-- When we try to COMMIT:
COMMIT;
-- If both transactions can be serialized, they succeed
-- If not, one gets: "ERROR: could not serialize access due to read/write dependencies"
```

### [Read Documentation](https://www.postgresql.org/docs/current/transaction-iso.html)

## D - Durability

- **Permanent changes**: Once committed, changes survive system failures
- **Crash recovery**: Data is safely stored in non-volatile memory
- _Example: Committed transfer persists after power outage_

**In practice**: ACID ensures that when you transfer money, it either completes entirely (debit + credit) or fails completely, maintaining data integrity even with multiple users and potential system failures.

# SQL Execution Plan

## What is an Execution Plan?

An **execution plan** (or query plan) is a roadmap that shows how the SQL database will execute your query. It reveals the step-by-step operations, access methods, and cost estimates the optimizer chooses to retrieve data.

## Key Components:

### 1. **Access Methods**

- **Sequential Scan**: Reads entire table (for unindexed queries)
- **Index Scan**: Uses index to find specific rows
- **Index Only Scan**: Retrieves data directly from index
- **Bitmap Heap Scan**: Combines multiple index results

### 2. **Join Methods**

- **Nested Loop**: For small tables or indexed joins
- **Hash Join**: For larger tables with equality conditions
- **Merge Join**: For sorted data with range conditions

### 3. **Operations**

- **Sort**: Orders results (can be expensive)
- **Aggregate**: GROUP BY and aggregate functions
- **Limit**: TOP/LIMIT operations

## Why Execution Plans Matter:

- **Performance tuning**: Identify bottlenecks
- **Index optimization**: See which indexes are used
- **Query rewriting**: Understand why slow queries are slow
- **Capacity planning**: Estimate resource requirements

**Bottom line**: Execution plans are your window into how the database thinks - essential for optimizing query performance!

## Example

Query to run

```sql
explain analyze
SELECT cars.manufacturer,
    cars.model,
    cars.country,
    cars.year,
    MAX(engines.horse_power) AS maximum_horse_power
FROM cars
    JOIN engines ON cars.engine_name = engines.name
WHERE cars.year > 2015
    AND cars.country = 'Germany'
GROUP BY cars.manufacturer,
    cars.model,
    cars.country,
    cars.year
HAVING MAX(engines.horse_power) > 200
ORDER BY maximum_horse_power DESC
LIMIT 2
```

Execution plan

# Query Execution Plan Analysis

## Execution Plan Breakdown:

| Operation               | Cost Estimate                      | Actual Performance                  | Details                                                                                                                  |
| ----------------------- | ---------------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| **Limit**               | cost=2.39..2.39<br>rows=1 width=27 | time=0.038..0.040<br>rows=2 loops=1 | Final result limitation                                                                                                  |
| **Sort**                | cost=2.39..2.39<br>rows=1 width=27 | time=0.037..0.038<br>rows=2 loops=1 | Sort Key: max(engines.horse_power) DESC<br>Sort Method: quicksort<br>Memory: 25kB                                        |
| **HashAggregate**       | cost=2.34..2.38<br>rows=1 width=27 | time=0.029..0.031<br>rows=3 loops=1 | Group Key: cars.manufacturer, model, country, year<br>Filter: max(engines.horse_power) > 200<br>Batches: 1, Memory: 24kB |
| **Hash Join**           | cost=1.16..2.29<br>rows=4 width=27 | time=0.021..0.023<br>rows=4 loops=1 | Hash Condition: engines.name = cars.engine_name                                                                          |
| **Seq Scan on engines** | cost=0.00..1.07<br>rows=7 width=13 | time=0.007..0.007<br>rows=7 loops=1 | Full table scan                                                                                                          |
| **Hash**                | cost=1.10..1.10<br>rows=4 width=32 | time=0.008..0.009<br>rows=4 loops=1 | Buckets: 1024, Batches: 1<br>Memory Usage: 9kB                                                                           |
| **Seq Scan on cars**    | cost=0.00..1.10<br>rows=4 width=32 | time=0.004..0.005<br>rows=4 loops=1 | Filter: year > 2015 AND country = 'Germany'<br>Rows Removed: 3                                                           |

## Performance Summary:

- **Planning Time**: 0.171 ms
- **Execution Time**: 0.075 ms
- **Total Rows Processed**: 7 cars → 4 filtered → 3 aggregated → 2 sorted → 2 limited

## Key Observations:

- **Efficient execution** with minimal memory usage
- **Small dataset** allows sequential scans without performance penalty
- **Hash join** effective for this data volume
- **Unexpected result**: LIMIT expected 1 row but returned 2

## Optimization Opportunities:

- Consider indexes if table sizes grow significantly
- Verify business logic for LIMIT clause expectation

# Database Indexing Summary

## Topic 1: Database Indexes

### Introduction to Indexes

- Database indexes are structures that improve query efficiency by enabling fast data access
- Without indexes, queries require sequential table scans (full table searches)
- Indexes allow direct access to specific rows using indexed columns

### Index Types

- **B-Tree indexes**: Most common, balanced tree structure
- **Hash indexes**: For equality comparisons
- **Bitmap indexes**: For low-cardinality data

### How Indexes Work

- Created on one or more table columns
- Database uses relevant indexes to quickly locate rows when querying indexed columns
- Store sorted values with pointers to actual data

### Advantages & Disadvantages

- **Advantages**: Faster queries, efficient data retrieval
- **Disadvantages**: Additional storage cost, update overhead during INSERT/UPDATE/DELETE operations

## Topic 2: B-Tree Data Structures

### B-Tree Introduction

- Balanced tree structure used in databases and file systems
- Designed for efficient insertions, deletions, and searches on large datasets
- Maintains tree balance and optimizes depth

### B-Tree Structure

- Consists of nodes with multiple keys and pointers
- Each node has minimum/maximum key/pointer limits
- Maintains balanced tree structure automatically

### B-Tree Operations

- **Insertion**: Adds new keys while maintaining balance
- **Deletion**: Removes keys while preserving structure
- **Search**: Efficiently traverses tree to find keys

### B-Tree Properties

- Automatic balancing maintains acceptable tree depth
- Efficient performance even with many insertions/deletions
- Widely used for primary and secondary indexes in databases

## Performance Considerations

### Index Usage Patterns

- **Efficient**: Equality searches on indexed columns
- **Inefficient**: Wildcard searches (LIKE '%pattern%')
- **Index-only scans**: When all needed columns are in the index

### Storage Impact

- Indexes consume additional disk space
- Balance between query performance and storage overhead
- Monitor index size vs. table size for optimization

## Key Takeaways

- Indexes dramatically improve query performance but add maintenance overhead
- B-Tree indexes are the most common and versatile index type
- Proper index design requires understanding query patterns and data characteristics
- Index-only scans provide optimal performance when possible

![B-tree](https://i.sstatic.net/SLW1g.png)

The key difference between B-tree and B+tree is that in a B-tree, both keys and data can be stored in all nodes (internal and leaf nodes), while in a B+tree, data is stored only in the leaf nodes and internal nodes contain only keys for navigation. This makes B+trees more efficient for range queries and sequential access because all leaf nodes are linked together, allowing quick traversal from one leaf to the next without backtracking through the tree hierarchy. Additionally, B+trees typically have higher fanout (more children per node) since internal nodes only store keys, not data, resulting in shorter trees and fewer disk accesses for search operations.

# Database Partitioning

## What is Partitioning?

Partitioning is a database technique that splits large tables into smaller, more manageable pieces called partitions, while still treating them as a single logical table. Each partition stores a subset of data based on specific rules.

## Types of Partitioning

### Range Partitioning

Data is divided based on ranges of values from a key column (typically dates, numeric values, or sequences). Ideal for time-series data or sequential numeric data.

### List Partitioning

Data is partitioned based on discrete values from a specified list (such as states, regions, or categories). Perfect for categorical data with known, finite values.

### Hash Partitioning

Data is distributed across partitions using a hash function applied to the partition key. Ensures even data distribution but makes targeted queries less efficient.

## Advantages

- **Performance**: Query performance improves through "partition pruning" where the database only scans relevant partitions
- **Manageability**: Easier maintenance operations (backup, restore, vacuum) on smaller partitions
- **Data Lifecycle**: Simplified archiving and purging of old data by dropping entire partitions
- **I/O Distribution**: Partitions can be placed on different storage for better I/O balancing

## Disadvantages

- **Complexity**: Adds architectural complexity to database design and operations
- **Planning Required**: Requires careful upfront planning of partition strategy
- **Index Management**: Indexes must be carefully designed (local vs. global)
- **Overhead**: Can introduce overhead if partition key isn't used in queries

## Maintenance Considerations

Partitioning requires ongoing maintenance including:

- Creating new partitions for incoming data
- Archiving or dropping old partitions based on retention policies
- Monitoring partition sizes and distributions
- Ensuring proper indexing strategies across partitions
- Managing partition constraints and dependencies

Proper automation through scripts or extensions like pg_partman is essential for production environments to handle routine partition maintenance tasks.

![Partition Example](https://oracle-base.com/articles/misc/images/partitioning/partitioning.png)

![Partition Example](https://learn.microsoft.com/en-us/azure/architecture/best-practices/images/data-partitioning/tablestorage.png)

## Performance Example

```sql
EXPLAIN ANALYZE
SELECT *
FROM pessoas
WHERE id = 10000;

EXPLAIN ANALYZE
SELECT *
FROM pessoas_partition_range
WHERE id = 10000;
```

The performance benefits of partitioning become evident when comparing query execution on partitioned versus non-partitioned tables:

### Non-Partitioned Table Execution Plan

| Metric              | Value                         |
| ------------------- | ----------------------------- |
| **Operation**       | Index Scan using pessoas_pkey |
| **Cost Range**      | 0.43..8.45                    |
| **Rows**            | 1 width=13                    |
| **Actual Time**     | 2.067..2.070 ms               |
| **Rows Returned**   | 1                             |
| **Loops**           | 1                             |
| **Index Condition** | (id = 10000)                  |
| **Planning Time**   | 0.880 ms                      |
| **Execution Time**  | 2.191 ms                      |

### Partitioned Table Execution Plan

| Metric              | Value                               |
| ------------------- | ----------------------------------- |
| **Operation**       | Index Scan using pessoas_part1_pkey |
| **Cost Range**      | 0.43..8.45                          |
| **Rows**            | 1 width=13                          |
| **Actual Time**     | 0.666..0.668 ms                     |
| **Rows Returned**   | 1                                   |
| **Loops**           | 1                                   |
| **Index Condition** | (id = 10000)                        |
| **Planning Time**   | 1.446 ms                            |
| **Execution Time**  | 0.683 ms                            |

**Advantage Demonstrated**: The partitioned query executed **68% faster** than the non-partitioned equivalent. This significant performance gain occurs because the database leverages partition pruning - it only needs to scan the specific partition containing the target ID, dramatically reducing I/O operations and search space. While the partitioned query had slightly higher planning time due to partition identification, the execution time was substantially better, demonstrating that the initial planning overhead is well worth the dramatic improvement in actual data retrieval performance.
