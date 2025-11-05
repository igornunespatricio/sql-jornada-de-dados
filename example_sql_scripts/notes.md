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
