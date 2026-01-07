# 📊 SQL Challenge – Pagila Database

## 📌 Project Overview

This repository contains the solution to a SQL challenge completed as part of a remote certification.
The objective of the project is to demonstrate solid understanding of:

- SQL fundamentals
- Joins and table relationships
- Aggregations and grouping
- Subqueries and CTEs
- Views and temporary tables
- SQL best practices using primary keys

The database used is **Pagila**, a relational schema that simulates a movie rental system.

---

## 🗂️ Repository Structure

scripts/
00_setup/
01_basics/
02_aggregations/
03_joins/
04_subqueries_cte/
05_objects/

docs/
README.md/
EnunciadoDataProject_SQL.Lógica.pdf


### Folder description

- **00_setup** → sanity checks and exploratory queries
- **01_basics** → SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
- **02_aggregations** → COUNT, SUM, AVG, GROUP BY, HAVING, date logic
- **03_joins** → INNER JOIN, LEFT JOIN, CROSS JOIN
- **04_subqueries_cte** → subqueries, CTEs, EXISTS / NOT EXISTS
- **05_objects** → views and temporary tables

---

## 🧠 Key SQL Concepts Covered

### Basic Queries
- Filtering with `WHERE`
- Sorting with `ORDER BY`
- Limiting results with `LIMIT`
- Pattern matching with `LIKE`
- Removing duplicates with `DISTINCT`

### Aggregations
- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` and `HAVING`
- Counting distinct values

### Joins
- `INNER JOIN` for related data
- `LEFT JOIN` to keep non-matching rows
- `CROSS JOIN` for all possible combinations

### Subqueries & CTEs
- Scalar subqueries
- `WITH` (CTE) for readability
- `EXISTS` / `NOT EXISTS` for exclusions

---

## 🧱 SQL Objects Used

### Views

A view was created to show the number of movies per actor:

```sql
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

Note: ORDER BY is applied when querying the view, not inside its definition.
```

## Temporary Tables

Temporary tables are used to store intermediate results.

Example:
```
DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS rentals_count
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
````

### ✅ Corrections After Instructor Feedback

The following improvements were applied after review:

- Aggregations now group by primary keys, not concatenated names
- Joins use the correct foreign keys between tables
- Views were corrected to avoid ORDER BY in definitions
- Temporary tables use DROP TABLE IF EXISTS before creation
- Subqueries were corrected to use the proper reference values
- Exact comparisons (=) were used where required
- Queries now correctly include entities with no related records using LEFT JOIN

### 🧪 How to Run the Queries

- Load the Pagila database into PostgreSQL
- Open the .sql files in the sql/ folder
- Execute scripts in order or individually
- Views and temp tables can be queried after creation

### 🚀 Final Notes

This project demonstrates practical SQL usage aligned with real-world data analysis scenarios.
All queries were written following best practices for clarity, correctness, and maintainability.
