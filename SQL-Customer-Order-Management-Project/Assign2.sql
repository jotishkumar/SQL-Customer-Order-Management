create database assign2;
use assign2;

RENAME TABLE `customers - customers` TO customer;
RENAME TABLE `items - items` TO items;
RENAME TABLE `orders - orders` TO orders;

-- [Question 1] use DDL commands to add a column to the customers table called street. add this column directly after the address column
ALTER TABLE customer
ADD COLUMN street varchar(255) after address;


-- [Question 2] update this column by extracting the street name from address
SELECT address, SUBSTRING_INDEX(address, ' ', -2) AS street_name
FROM customer;

set sql_safe_updates = 0;
UPDATE customer
SET street = SUBSTRING_INDEX(address, ' ', -2);


-- [Question 3] Using DDL commands, add a column called stock_level to the items table.
ALTER TABLE items
ADD COLUMN stock_level varchar(255);


-- [Question 4] Use CASE to update the stock_level column in the following way:
-- low stock if the amount is below 20
-- moderate stock if the amount is between 20 and 50
-- high stock if the amount is over 50

update items
SET stock_level = case
when amount_in_stock<20 then "Low Stock"
when amount_in_stock between 20 and 50 then "Moderate"
else "High Stock"
end;
select amount_in_stock, stock_level from items;

-- Analysis 


-- [Question 5] In a SIMPLE SELECT query, make a column called price_label in which label each item's price as:
-- low price if its price is below 10
-- moderate price if its price is between 10 and 50
-- high price if its price is above 50
-- "unavailable" in all other cases
-- order this query by price in descending order

SELECT item_price,
       CASE 
           WHEN item_price < 10 THEN 'low '
           WHEN item_price between 10 and 50 THEN 'moderate'
           WHEN item_price > 50 THEN 'high '
           ELSE 'unavailable'
       END AS price_label
FROM items
ORDER BY item_price DESC;


-- [Question 6]
-- Find out the total number of orders per street per city. Your results should show street, city and total_orders
-- results should be ordered by street in ascending order and cities in descending order (Hint: USE JOIN AND GROUP BY)
SELECT cu.street, cu.city, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customer cu ON o.customer_id = cu.customer_id
GROUP BY cu.street, cu.city
ORDER BY cu.street ASC, cu.city DESC;

-- [Question 7]
-- USING A JOIN, select the following:
-- customer_id, last name, address, phone number, order id, order date, item name, item type, and item price. 
SELECT cu.customer_id, cu.last_name, cu.address, cu.phone_number, 
       o.order_id, o.order_date, 
       i.item_name, i.item_type, i.item_price
FROM orders o
JOIN customer cu ON o.customer_id = cu.customer_id
JOIN items i ON o.item_id = i.item_id;

-- [Question 8]
-- USING A JOIN, select customer_ids, first names, last names and addresses of customers who have never placed an order.
-- Only these four columns should show in your results

SELECT cu.customer_id, cu.first_name, cu.last_name, cu.address
FROM customer cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- [Question 9]
-- DO THE EXACT SAME AS ABOVE USING A MULTI-ROW SUBQUERY IN THE WHERE CLAUSE
-- select customer_ids, first_names, last_names and addresses of customers who have never placed an order.
-- Only these four columns should show in your results

SELECT customer_id, first_name, last_name, address
FROM customer
WHERE customer_id NOT IN (SELECT customer_id FROM orders);


-- [Question 10]
-- USING A CORRELATED SUBQUERY IN THE WHERE CLAUSE:
-- select item id, item name, item type and item price for all those items that have a price higher than the average price FOR THEIR ITEM TYPE (NOT average of the whole column)
-- order your result by item type; (hint: Use correlated subquery to match items table with itself by matching item_type) 


-- [Question 11]
-- USING A SUBQUERY IN THE WHERE CLAUSE, find out customer ids, the order date and item id of their most recent order
-- order your result by customer_id

SELECT o.customer_id, o.order_date, o.item_id
FROM orders o
WHERE o.order_date = (SELECT MAX(order_date) FROM orders WHERE customer_id = o.customer_id)
ORDER BY o.customer_id;

-- [Question 12] 
-- USE A JOIN to find out which customers placed an order in their birth MONTH
-- Your results should show customer_id, date_of_birth, order_date (hint: match month of order_date with month of date_of_birth)

SELECT cu.customer_id, cu.date_of_birth, o.order_date
FROM customer cu
JOIN orders o ON cu.customer_id = o.customer_id
WHERE MONTH(cu.date_of_birth) = MONTH(o.order_date)
  AND YEAR(cu.date_of_birth) = YEAR(o.order_date);

-- [Question 13]
-- USE A MULTI COLUMN SUBQUERY to find out which customers placed an order on their birth DAY (month+day like date of birth is 4th August, 2001 while order date is 4th August)
-- Your results should show customer_id and date_of_birth

SELECT cu.customer_id, cu.date_of_birth
FROM customer cu
WHERE (DAY(cu.date_of_birth), MONTH(cu.date_of_birth)) IN (
    SELECT DAY(o.order_date), MONTH(o.order_date)
    FROM orders o
    WHERE o.customer_id = cu.customer_id
);







