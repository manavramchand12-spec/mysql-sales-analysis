CREATE DATABASE ecommerce;
USE ecommerce;

SELECT * FROM `amazon sale report` LIMIT 10;
SELECT Category, SUM(Amount) AS total_sales
FROM `amazon sale report`
GROUP BY Category
ORDER BY total_sales DESC;

SELECT `ship-state`, SUM(Amount) AS total_sales
FROM `amazon sale report`
GROUP BY `ship-state`
ORDER BY total_sales DESC;

SELECT 
    MONTH(STR_TO_DATE(Date, '%m-%d-%y')) AS month,
    SUM(Amount) AS total_sales
FROM `amazon sale report`
GROUP BY month
ORDER BY month;

-- Shows total sales by category ONLY for Maharashtra

SELECT Category, 
       ROUND(SUM(Amount), 2) AS total_sales
FROM `amazon sale report`
WHERE `ship-state` = 'MAHARASHTRA'
GROUP BY Category
ORDER BY total_sales DESC;

-- Shows top 5 states by total sales

SELECT `ship-state`,
       ROUND(SUM(Amount), 2) AS total_sales
FROM `amazon sale report`
GROUP BY `ship-state`
ORDER BY total_sales DESC
LIMIT 5;

-- Shows top 5 best-selling products (by SKU)

SELECT SKU,
       ROUND(SUM(Amount), 2) AS total_sales
FROM `amazon sale report`
GROUP BY SKU
ORDER BY total_sales DESC
LIMIT 5;

-- Shows sales by Category AND SKU

SELECT Category,
       SKU,
       ROUND(SUM(Amount), 2) AS total_sales
FROM `amazon sale report`
GROUP BY Category, SKU
ORDER BY total_sales DESC
LIMIT 10;

-- Shows total sales by State AND Category

SELECT `ship-state`,
       Category,
       ROUND(SUM(Amount), 2) AS total_sales
FROM `amazon sale report`
GROUP BY `ship-state`, Category
ORDER BY `ship-state`, total_sales DESC;

-- Shows TOP category in EACH state

SELECT t1.`ship-state`,
       t1.Category,
       t1.total_sales
FROM (
    SELECT `ship-state`,
           Category,
           SUM(Amount) AS total_sales
    FROM `amazon sale report`
    GROUP BY `ship-state`, Category
) t1
JOIN (
    SELECT `ship-state`,
           MAX(total_sales) AS max_sales
    FROM (
        SELECT `ship-state`,
               Category,
               SUM(Amount) AS total_sales
        FROM `amazon sale report`
        GROUP BY `ship-state`, Category
    ) t2
    GROUP BY `ship-state`
) t2
ON t1.`ship-state` = t2.`ship-state`
AND t1.total_sales = t2.max_sales;


-- Shows number of cancelled vs completed orders

SELECT Status,
       COUNT(*) AS total_orders
FROM `amazon sale report`
GROUP BY Status;

-- Shows only meaningful business statuses

SELECT 
    CASE 
        WHEN Status = 'Cancelled' THEN 'Cancelled'
        WHEN Status = 'Shipped - Delivered to Buyer' THEN 'Completed'
        ELSE 'Other'
    END AS order_status,
    COUNT(*) AS total_orders
FROM `amazon sale report`
GROUP BY order_status;

-- Calculates cancellation percentage

SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS cancellation_rate_percentage
FROM `amazon sale report`;
