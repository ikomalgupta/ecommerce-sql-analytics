# E-Commerce SQL Project

## Overview
*This SQL project focuses on analyzing an e-commerce business using a relational database.* It includes a schema setup, data insertion, and various SQL queries that showcase different skill levels—ranging from basic to advanced.

## Project Contents
* `Ecommerce_Database_Script.sql`: This script creates the database and 8 tables:
  * **Customers**
  * **Products**
  * **Orders**
  * **Payments**
  * **Category**
  * **OrderDetails**
  * **Shippers**
  * **Suppliers**
* `Ecommerce_Dataset_Analysis(Query).sql`: Contains various SQL queries for data analysis.

## Database Schema
The database consists of the following interconnected tables:
* **Customers**: *Stores customer information.*
* **Orders**: *Captures order details including customer and shipper.*
* **Products**: *Contains product-related data including categories.*
* **Payments**: *Records payment methods used.*
* **Category**: *Lists product categories and their active status.*
* **OrderDetails**: *Line-item level order information.*
* **Shippers**: *Data about shipping companies.*
* **Suppliers**: *Information about product suppliers.*

## SQL Analysis Performed

### Basic Level Queries
* List all customers with email and city
* Count total number of products per sub-category
* Show all active product categories
* Retrieve all payment types allowed
* List all orders along with their total order amount
* Get details of all suppliers in the USA
* List customers from a specific state
* View all orders shipped by a specific shipper
* Find products with a market price greater than 1000
* Count number of orders made using each payment type

### Intermediate Level Queries
* Calculate total revenue for each month
* Find the top 5 best-selling products
* Identify customers who have placed more than one order
* Determine the average order value for each customer
* List products that have not been ordered in the last 6 months
* Find the total quantity of each product in stock
* Calculate the total revenue for each product category
* Identify the most popular payment method used by customers

### Advanced SQL Queries
* Total Quantity Sold per Product
* Number of Orders Placed by Each Customer
* Total Sales per Category
* Orders Shipped and Their Delivery Time
* List All Customers Who Made Payments Using a Specific Type
* Products Supplied by Each Supplier
* Average Price per Product Category
* Number of Products Shipped by Each Shipper
* Find the Most Expensive Product in Each Category
* Revenue Generated per Customer

## How to Run This Project
1. Clone this repository to your local machine.
2. Use any SQL client like SSMS, MySQL Workbench, DBeaver, etc.
3. Run the `Ecommerce_Database_Script.sql` file to create the tables and data.
4. Run analysis queries from `Ecommerce_Dataset_Analysis(Query).sql`.

## Schema Reference

![`Ecommerce_Database_Schema`](schema.png)

## Conclusion
This project offers a complete walk-through of a practical e-commerce business scenario, showcasing data extraction, transformation, and insights using SQL. It demonstrates proficiency in **SQL joins**, **aggregations**, **date manipulation**, and advanced analytics using **CTEs** and **window functions**.

## Skills Demonstrated
* **SQL Joins**
* **Aggregate Functions**
* **Window Functions** (RANK, ROW_NUMBER, etc.)
* **CTEs** (Common Table Expressions)
* **Date Functions**
* **Filtering and Subqueries**
* **Database Design & Normalization**