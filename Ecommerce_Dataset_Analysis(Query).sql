
-- Displaying data from all the tables - 

SELECT * FROM customers ; 
SELECT * FROM orders; 
SELECT * FROM products;
SELECT * FROM orderdetails; 
SELECT * FROM category;
SELECT * FROM payments; 
SELECT * FROM shippers; 
SELECT * FROM suppliers;


-- Basic Level Questionscustomer

-- 1.List all customers along with their email and city.

SELECT CONCAT(FirstName, ' ', LastName) AS Full_Name, Email, City 
FROM customers;

-- 2.Find the total number of customers in each country. 

SELECT Country, COUNT(CustomerID) As cnt 
FROM customers
GROUP BY Country 
ORDER BY cnt DESC;

-- 3.Show all products with their sale price and market price. 

SELECT Product , Sale_Price , Market_price 
FROM products ;

-- 4.List all active categories.

SELECT CategoryName, Active 
FROM category 
WHERE Active = 'Yes' ;

-- 5.Retrieve all payment methods that are allowed. 

SELECT PaymentType , Allowed
FROM payments 
WHERE Allowed = 'Yes';

-- 6.Display all orders along with the order date and ship date.

SELECT OrderID, OrderDate, ShipDate
FROM orders;

-- 7. Find the number of products in each sub-category.

SELECT Sub_Category, COUNT(ProductID) AS cnt 
FROM products 
GROUP BY Sub_Category
ORDER BY cnt DESC;

-- 8.List all suppliers along with their company name and phone number.

SELECT SupplierID, CompanyName, Phone 
FROM suppliers ;

-- 9.Get the most recent customers (based on DateEntered).

SELECT CustomerID, FirstName, DateEntered 
FROM customers
ORDER BY DateEntered ASC;

-- 10.Find all products that have a sale price less than their market price.

SELECT ProductID, Product, Sale_Price, Market_Price 
FROM products 
WHERE Sale_Price < Market_Price ;


-- Intermediate Level Questions

-- 11.Get the total quantity sold for each product using OrderDetails.

SELECT Product, SUM(Quantity) AS total_quantity 
FROM products AS p LEFT JOIN OrderDetails AS od 
ON p.ProductID = od.ProductID
GROUP BY Product 
ORDER BY total_quantity DESC ;


-- 12.List customers who have placed at least one order (JOIN Orders and Customers).

SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) AS cnt 
FROM customers AS c JOIN orders AS o 
ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.FirstName
HAVING COUNT(o.OrderID) >=1
ORDER BY cnt DESC ;

-- 13.Find the number of orders placed by each customer.

SELECT c.CustomerID, COUNT(o.OrderID) AS cnt 
FROM customers AS c LEFT JOIN orders AS o 
ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID 
ORDER BY cnt DESC ;

-- 14.Show total sales (Quantity * Sale_Price) per product.

SELECT p.ProductID, p.Product, SUM(od.Quantity*p.Sale_Price) AS total_Sales 
FROM products AS p JOIN orderdetails AS od 
ON p.ProductID = od.ProductID 
GROUP BY p.ProductID, p.Product
ORDER BY total_sales DESC, p.Product ASC ;

-- 15.Display the total number of orders shipped by each shipper.

SELECT s.ShipperID, s.CompanyName, COUNT(o.OrderID) AS cnt 
FROM shippers AS s JOIN orders AS o 
ON o.ShipperID = s.ShipperID 
GROUP BY s.ShipperID, s.CompanyName
ORDER BY cnt DESC, s.CompanyName ASC ;

-- 16.List products along with their category names.

SELECT c.CategoryName, p.Product 
FROM Category AS c JOIN Products AS p 
ON p.Category_ID = c.CategoryID 
ORDER BY c.CategoryName ASC;

-- 17.Get the average sale price of products in each category.

-- 1st way
SELECT c.CategoryName, AVG(p.Sale_Price) AS average_sale_price
FROM Category AS c JOIN Products AS p 
ON p.Category_ID = c.CategoryID 
GROUP BY c.CategoryName
ORDER BY c.CategoryName ASC;

-- 2nd way
SELECT DISTINCT c.CategoryName, ROUND(AVG(p.Sale_Price) OVER(PARTITION BY c.CategoryName),2) AS average_sale_price
FROM Category AS c JOIN Products AS p 
ON p.Category_ID = c.CategoryID 
ORDER BY c.CategoryName ASC;

-- 18.Find suppliers who supply more than 5 different products.

SELECT s.SupplierID, s.CompanyName, COUNT(DISTINCT p.ProductID) AS cnt
FROM Suppliers AS s JOIN OrderDetails AS od 
ON s.SupplierID = od.SupplierID 
JOIN Products AS p ON od.ProductID = p.ProductID 
GROUP BY s.SupplierID, s.CompanyName
HAVING COUNT(DISTINCT p.Product) > 5
ORDER BY cnt DESC ;

-- 19.Display customers and their total amount spent across all orders.

SELECT c.CustomerID, CONCAT(FirstName,' ',LAstName) AS Fullname, 
SUM(od.Quantity * p.Sale_Price) AS total_amount_spent 
FROM customers AS c JOIN Orders AS o 
ON c.CustomerID = o.CustomerID JOIN OrderDetails AS od 
ON o.OrderID = od.OrderID JOIN Products AS p 
ON p.ProductID = od.ProductID 
GROUP BY c.CustomerID, Fullname 
ORDER BY total_amount_spent DESC ;

-- 20.Find the top 5 products with the highest total sales value.

SELECT ProductID, Product, SUM(Sale_Price) AS total_Sales_value 
FROM products 
GROUP BY ProductID, Product
ORDER BY total_Sales_value DESC
LIMIT 5;


-- Advanced Level Questions


-- 21.Use a CTE to find the total number of products in each category and display only those with more than 500 products.

WITH cte AS (
SELECT c.CategoryName, COUNT(p.Product) AS cnt 
FROM category AS c JOIN products AS p 
ON  c.CategoryID = p.Category_ID 
GROUP BY c.CategoryName)

SELECT CategoryName , cnt 
FROM cte
WHERE cnt > 500;

-- 22.Find the top 3 customers who placed the highest number of orders using a window function.

SELECT c.CustomerID, c.FirstName , COUNT(o.OrderID) AS cnt, 
ROW_NUMBER() OVER(ORDER BY COUNT(o.OrderID) DESC) AS rnk
FROM customers AS c JOIN orders AS o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.FirstName
LIMIT 3;

-- 23.For each product, calculate its rank based on total revenue generated.

SELECT p.ProductID, SUM(p.Sale_Price*od.Quantity) AS total_revenue,
DENSE_RANK() OVER(ORDER BY SUM(p.Sale_Price * od.Quantity) DESC) AS rnk 
FROM products AS p JOIN orderdetails AS od 
ON p.ProductID = od.ProductID 
GROUP BY p.ProductID;

-- 24.Show the month-wise total revenue.
SELECT MONTH(OrderDate) AS month_ , MONTHNAME(OrderDate) AS month_name, SUM(od.Quantity*p.Sale_Price) As total_revenue 
FROM orders AS o JOIN OrderDetails AS od 
ON o.OrderID = od.OrderID 
JOIN Products AS p ON od.ProductID = p.ProductID 
GROUP BY month_,month_name 
ORDER BY month_ ASC;


-- 25.Identify customers who placed consecutive orders within 7 days (use LAG or LEAD).

WITH OrderDates AS (
SELECT c.CustomerID,o.OrderID,o.OrderDate,
LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrderDate
FROM Orders AS o JOIN Customers AS c ON o.CustomerID = c.CustomerID)

SELECT CustomerID,OrderID,OrderDate,PreviousOrderDate,
DATEDIFF(OrderDate, PreviousOrderDate) AS DaysBetweenOrders
FROM OrderDates
WHERE PreviousOrderDate IS NOT NULL
AND DATEDIFF(OrderDate, PreviousOrderDate) <= 7
ORDER BY CustomerID, OrderDate;

-- 26.Using a window function, find the cumulative revenue generated by each product over time.

SELECT p.Product, o.OrderDate, p.Sale_price*od.Quantity AS total_revenue, 
SUM(p.Sale_price*od.Quantity) OVER(PARTITION BY p.Product ORDER BY o.OrderDate) AS cumulative_sum
FROM products AS p JOIN orderdetails AS od 
ON p.ProductID = od.ProductID
JOIN orders AS o ON od.OrderID = o.OrderID;

-- 27.Find the difference between market price and sale price per product and rank products with the highest discount.

SELECT Product, Market_Price, Sale_Price, Market_Price - Sale_Price AS price_difference, 
DENSE_RANK() OVER(ORDER BY (Market_Price - Sale_Price) DESC) AS rank_
FROM products; 

-- 28.Write a query to return the top-selling product per category.

WITH top_selling_product AS (
SELECT c.CategoryID, c.CategoryName , Product, SUM(od.Quantity) AS total_quantity, 
DENSE_RANK() OVER(PARTITION BY c.CategoryID ORDER BY SUM(od.Quantity) DESC) AS rank_
FROM category AS c JOIN products AS p 
ON c.CategoryID = p.Category_ID 
JOIN orderdetails AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName, Product)

SELECT CategoryName, Product, total_quantity
FROM top_selling_product
WHERE rank_ =1 
ORDER BY total_quantity DESC;

-- 29.Use a CTE to calculate total revenue per supplier and return those whose revenue exceeds average revenue.

WITH supplier_revenue AS(
SELECT s.SupplierID,s.CompanyName, ROUND(SUM(od.Quantity*p.Sale_Price),2) AS total_revenue
FROM suppliers AS s JOIN orderdetails AS od 
ON s.SupplierID = od.SupplierID 
JOIN products AS p 
ON od.ProductID = p.ProductID
GROUP BY s.SupplierID,s.CompanyName
),
 overall_revenue AS(
SELECT ROUND(AVG(total_revenue),0) AS average_revenue
FROM supplier_revenue)

SELECT SupplierID, Companyname, total_revenue, average_revenue 
FROM supplier_revenue, overall_revenue 
WHERE total_revenue > average_revenue ;


-- 30.Calculate the average delivery Days per shipper and find the one with the fastest delivery performance.

SELECT s.ShipperID, s.CompanyName,
ROUND(AVG(TIMESTAMPDIFF(DAY, o.OrderDate, o.DeliveryDate)),2) AS average_delivery_days
FROM shippers AS s 
JOIN orders AS o ON s.ShipperID = o.ShipperID 
GROUP BY s.ShipperID, s.CompanyName
ORDER BY average_delivery_days ASC
LIMIT 1;


















































































