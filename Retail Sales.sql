create database retail_sales;
use retail_sales;

CREATE TABLE customers(
customer_id INTEGER NOT NULL,
gender VARCHAR(100) NOT NULL,
age INTEGER,
city VARCHAR(30),
signup_date DATETIME,
loyalty_member VARCHAR(10),
PRIMARY KEY (customer_id)
);

CREATE TABLE orders(
order_id INTEGER,
customer_id INTEGER NOT NULL,
product_id INTEGER,
order_date DATETIME,
quantity INTEGER,
payment_method VARCHAR(30)
);

CREATE TABLE products(
product_id INTEGER,
product_name VARCHAR(100),
category VARCHAR(50),
price INTEGER
);

ALTER TABLE customers
MODIFY customer_id VARCHAR(10);

ALTER TABLE orders
MODIFY order_id VARCHAR(10),
MODIFY customer_id VARCHAR(10),
MODIFY product_id VARCHAR(10);

ALTER TABLE products
MODIFY product_id VARCHAR(10);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/customers (1).csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/orders (1).csv' 
INTO TABLE orders 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/products (1).csv' 
INTO TABLE products 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- How many total customers are in the dataset?

SELECT COUNT(customer_id)
from customers;

-- How many orders were placed?

SELECT COUNT(order_id)
from orders;

SELECT DISTINCT COUNT(order_id)
from orders;

-- Which cities have the most customers?

SELECT city, count(customer_id)
from customers
GROUP BY city
ORDER BY COUNT(customer_id) DESC
LIMIT 10;

-- What are the top 5 most purchased products?

SELECT DISTINCT products.product_name, count(orders.product_id) AS PRODUCT_COUNT
from products
LEFT JOIN orders ON orders.product_id = products.product_id
GROUP BY product_name
ORDER BY COUNT(product_id) DESC
LIMIT 5;

-- What is the total revenue generated?

SELECT SUM(orders.quantity * products.price) AS total_revenue
FROM products
LEFT JOIN orders ON orders.product_id = products.product_id;

-- Which product category generates the most revenue?

SELECT 
    products.category,
    SUM(orders.quantity) AS total_quantity,
    SUM(orders.quantity * products.price) AS total_revenue
FROM orders
LEFT JOIN products ON orders.product_id = products.product_id
GROUP BY products.category
ORDER BY total_revenue DESC;

-- What is the average order quantity?

SELECT SUM(orders.quantity)/COUNT(orders.quantity) AS average_order_quantity
from orders;

SELECT AVG(orders.quantity) AS average_order_quantity
from orders;

-- Which cities generate the most revenue?

SELECT customers.city, SUM(orders.quantity * products.price) AS total_revenue
from orders
JOIN products ON orders.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.city
ORDER BY total_revenue DESC;

-- Who are the top 10 highest spending customers?

 SELECT customers.customer_id, SUM(orders.quantity * products.price) AS total_spend
 from orders
 JOIN products ON orders.product_id = products.product_id
 JOIN customers ON orders.customer_id = customers.customer_id
 GROUP BY customers.customer_id
 ORDER BY total_spend DESC
 LIMIT 10;
 
 -- Which month has the highest sales?

SELECT MONTHNAME(orders.order_date) AS order_month, SUM(orders.quantity * products.price) AS sales
from orders
JOIN products ON orders.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY order_month
ORDER BY sales DESC;

-- What is the average spending per customer?

SELECT AVG(total_spend) AS avg_spend
from (
SELECT orders.customer_id, SUM(orders.quantity * products.price) AS total_spend
from orders
JOIN products ON orders.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY orders.customer_id
) AS customer_spending;

-- Which product category sells the most units?

SELECT products.category, SUM(orders.quantity) AS sold_units
from orders
JOIN products ON orders.product_id = products.product_id
GROUP BY products.category
ORDER BY sold_units DESC
LIMIT 1;

-- What is the most common payment method?

SELECT orders.payment_method
from orders
GROUP BY orders.payment_method
ORDER BY COUNT(orders.order_id) DESC
LIMIT 1;