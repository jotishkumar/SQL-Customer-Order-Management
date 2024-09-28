## Project Title
Customer, Order, and Item SQL Database Project

## Description
This project involves designing and querying a database with three tables: customers, orders, and items. The goal is to manage and analyze customer data, order history, and 
inventory using SQL queries. The project demonstrates various SQL operations like data retrieval, aggregation, joins, and updates.

## Database Structure
The database contains three tables:
- **customers**: Stores customer details like name, contact information, and address.
- **orders**: Logs order information, linking customers to the items they have purchased.
- **items**: Contains item details such as name, price, and stock levels.

The `customer_id` in the orders table links to the `customer_id` in the customers table, and `item_id` links to the `item_id` in the items table.

## Technologies Used
SQL
- MySQL

## SQL Queries
Some key queries used in the project include:
- **List all orders along with customer and item details**:
  ```sql
  SELECT o.order_id, c.first_name, c.last_name, i.item_name, o.order_date
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  JOIN items i ON o.item_id = i.item_id;
  ```
- **Find the total number of orders per customer**:
  ```sql
  SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id;
  ```

  **Author**: [Jotish Kumar](https://github.com/jotishkumar)

