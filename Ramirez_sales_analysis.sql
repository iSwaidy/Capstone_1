/* 
Cris Ramirez
04/27/2026            -- Assigned Manger: Shruti Reddy                       
Capstone 01           -- Territory: Maryland
*/

USE sample_sales;
SHOW TABLES;
DESCRIBE inventory_categories;

-- Check Management table
SELECT * FROM management
WHERE salesmanager= 'Shruti Reddy';

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?

SELECT * From store_sales;
SELECT * From store_locations
WHERE State = 'Maryland';

SELECT 
		SUM(sale_amount) AS 'Total Revenue',
        MIN(Transaction_Date) AS 'Start Date',
        MAX(Transaction_Date) AS 'End Date'
FROM store_sales s
JOIN store_locations sl 
	ON s.store_id = sl.storeid
WHERE State = 'Maryland';

-- =======================================
-- RESULTS: 
-- Total Revenue - $11,451,615.09 
-- Start Date: 2022-01-01
-- End Date: 2025-12-31
-- =======================================

-- What is the month by month revenue breakdown for the sales territory?

SELECT
    YEAR(Transaction_Date) AS 'Year',
    MONTHNAME(Transaction_Date) AS 'Month',
    CONCAT('$', FORMAT(SUM(Sale_Amount), 2)) AS 'Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE State = 'Maryland'
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date), MONTHNAME(Transaction_Date)
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date);

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

SELECT 
	CONCAT('$', FORMAT(SUM(CASE WHEN sl.state = 'Maryland' THEN s.sale_amount ELSE 0 END), 2)) AS 'Maryland Total Revenue',
	CONCAT('$', FORMAT(SUM(CASE WHEN m.region = 'Northeast' THEN s.sale_amount ELSE 0 END), 2)) AS 'Northeast Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
JOIN management m ON sl.state = m.state;

-- =======================================
-- RESULTS: 
-- Maryland Total Revenue: $11,451,615.09 
-- Northeast Total Revnue: $24,237526.98
-- =======================================

-- What is the number of transactions per month and average transaction size by product category for the sales territory?

SELECT
    YEAR(Transaction_Date) AS 'Year',
    MONTHNAME(Transaction_Date) AS 'Month', ic.Category,
    COUNT(id) AS 'Number of Transactions',
    AVG(Sale_Amount) AS 'Avg Transaction Size'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
JOIN products p ON s.prod_num = p.prodnum
JOIN inventory_categories ic ON p.categoryid = ic.categoryid
WHERE sl.state = 'Maryland'
GROUP BY YEAR(s.transaction_date), MONTH(s.transaction_date), MONTHNAME(s.transaction_date), ic.category
ORDER BY YEAR(s.transaction_date), MONTH(s.transaction_date);


-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?

-- What is your recommendation for where to focus sales attention in the next quarter?


