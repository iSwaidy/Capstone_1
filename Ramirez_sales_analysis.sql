/* 
Cris Ramirez
04/27/2026            -- Assigned Manger: Shruti Reddy                       
Capstone 01           -- Territory: Maryland
*/

USE sample_sales;
SHOW TABLES;

-- Check Management table
SELECT * FROM management
WHERE salesmanager= 'Shruti Reddy';

-- Check Store_Locations table
SELECT * FROM store_locations
WHERE state = 'Maryland';

-- 1. What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?

SELECT 
	MIN(Transaction_Date) AS 'Start Date',
	MAX(Transaction_Date) AS 'End Date',
	CONCAT('$', FORMAT(SUM(sale_amount), 2)) AS 'Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE State = 'Maryland';

-- =======================================
-- RESULTS: 
-- Total Revenue - $11,451,615.09 
-- Start Date: 2022-01-01
-- End Date: 2025-12-31
-- =======================================

-- 2. What is the month by month revenue breakdown for the sales territory?
						
                        -- Month by month revenue - PRESENTATION VERSION (wrapped)
SELECT
    CONCAT(MONTHNAME(Transaction_Date), ' ', YEAR(Transaction_Date)) AS 'Month',
    CONCAT('$', FORMAT(SUM(Sale_Amount), 2)) AS 'Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE State = 'Maryland'
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date), 
	MONTHNAME(Transaction_Date), CONCAT(MONTHNAME(Transaction_Date), ' ', YEAR(Transaction_Date))
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date);

						-- Month by month revenue - EXCEL EXPORT VERSION (separate columns)
SELECT
    YEAR(Transaction_Date) AS 'Year',
    MONTHNAME(Transaction_Date) AS 'Month',
    (SUM(Sale_Amount)) AS 'Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE State = 'Maryland'
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date), MONTHNAME(Transaction_Date)
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date);

-- 3. Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

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

-- 4. What is the number of transactions per month and average transaction size by product category for the sales territory?

						-- Transactions by category per month - PRESENTATION VERSION (WRAPPED)
SELECT
    CONCAT(MONTHNAME(s.Transaction_Date), ' ', YEAR(s.Transaction_Date)) AS 'Month',
    ic.Category,
    COUNT(s.id) AS 'Number of Transactions',
    CONCAT('$', FORMAT(ROUND(AVG(Sale_Amount), 2), 2)) AS 'Average Transaction'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
JOIN products p ON s.prod_num = p.prodnum
JOIN inventory_categories ic ON p.categoryid = ic.categoryid
WHERE sl.state = 'Maryland'
GROUP BY YEAR(s.transaction_date), MONTH(s.transaction_date), 
	MONTHNAME(s.transaction_date), CONCAT(MONTHNAME(s.Transaction_Date), ' ', YEAR(s.Transaction_Date)), ic.category
ORDER BY YEAR(s.transaction_date), MONTH(s.transaction_date);

						-- Transactions by category per month - EXCEL EXPORT VERSION (separate columns)
SELECT
    YEAR(Transaction_Date) AS 'Year',
    MONTHNAME(Transaction_Date) AS 'Month', ic.Category,
    COUNT(id) AS 'Number of Transactions',
    (AVG(Sale_Amount)) AS 'Average Transaction'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
JOIN products p ON s.prod_num = p.prodnum
JOIN inventory_categories ic ON p.categoryid = ic.categoryid
WHERE sl.state = 'Maryland'
GROUP BY YEAR(s.transaction_date), MONTH(s.transaction_date), MONTHNAME(s.transaction_date), ic.category
ORDER BY YEAR(s.transaction_date), MONTH(s.transaction_date);

-- 5. Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?

SELECT
    RANK() OVER (ORDER BY SUM(s.Sale_Amount) DESC) AS 'Rank',
    sl.StoreLocation AS 'Store',
    CONCAT('$', FORMAT(SUM(s.Sale_Amount),2)) AS 'Total Revenue'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE sl.State = 'Maryland'
GROUP BY sl.StoreId, sl.StoreLocation
ORDER BY SUM(s.Sale_Amount) DESC;
    
-- 6. What is your recommendation for where to focus sales attention in the next quarter?


SELECT
    CONCAT(MONTHNAME(MIN(Transaction_Date)), ' ', YEAR(MIN(Transaction_Date))) AS 'Start Date',
    CONCAT('$', FORMAT(SUM(CASE WHEN YEAR(Transaction_Date) = 2022 AND MONTH(Transaction_Date) = 1 THEN Sale_Amount ELSE 0 END), 2)) AS 'First Month Revenue',
    CONCAT(MONTHNAME(MAX(Transaction_Date)), ' ', YEAR(MAX(Transaction_Date))) AS 'End Date',
    CONCAT('$', FORMAT(SUM(CASE WHEN YEAR(Transaction_Date) = 2025 AND MONTH(Transaction_Date) = 12 THEN Sale_Amount ELSE 0 END), 2)) AS 'Last Month Revenue',
    CONCAT(FORMAT(((SUM(CASE WHEN YEAR(Transaction_Date) = 2025 AND MONTH(Transaction_Date) = 12 THEN Sale_Amount ELSE 0 END) - 
    SUM(CASE WHEN YEAR(Transaction_Date) = 2022 AND MONTH(Transaction_Date) = 1 THEN Sale_Amount ELSE 0 END)) / 
    SUM(CASE WHEN YEAR(Transaction_Date) = 2022 AND MONTH(Transaction_Date) = 1 THEN Sale_Amount ELSE 0 END)) * 100, 2), '%') AS 'Growth %'
FROM store_sales s
JOIN store_locations sl ON s.store_id = sl.storeid
WHERE sl.State = 'Maryland';

-- Growth % overtime is 74.75% increase --

-- ============================================== --
SELECT
    CONCAT('$', FORMAT(MAX(Sale_Amount_Total), 2)) AS 'Highest Store Revenue',
    CONCAT('$', FORMAT(MIN(Sale_Amount_Total), 2)) AS 'Lowest Store Revenue',
    CONCAT(FORMAT(((MAX(Sale_Amount_Total) - MIN(Sale_Amount_Total)) / MIN(Sale_Amount_Total)) * 100, 2), '%') AS '% Difference'
FROM (
    SELECT
        StoreLocation,
        SUM(s.Sale_Amount) AS Sale_Amount_Total
    FROM store_sales s
    JOIN store_locations sl ON s.store_id = sl.storeid
    WHERE sl.State = 'Maryland'
    GROUP BY sl.StoreId, sl.StoreLocation
) AS StoreTotals;

-- 2,914.59% Difference
-- ============================================== --

/*

Analysis:

- Maryland generated $11,451,615.09 in total revenue from January 2022 to December 2025
- Maryland accounts for 47% of the entire Northeast region's revenue
- Revenue grew from $190,064.90 in January 2022 to $332,129.99 in December 2025 (That's a 74.75% increase over 4 years)
- North Harford is a massive outlier at $8,708,119. Annapolis is the lowest performing store at $288,865.31 thats a 2,914.59% difference between both stores.

Recommendation:

For Q1 2026, I recommend focusing sales attention on the Annapolis store, which ranked last at $288,865.31. (Query5)
Given that Technology & Accessories consistently drives the highest average transaction value across all stores, 
Annapolis should prioritize promoting tech products to increase average transaction size. (Query4)
Additionally, Q1 historically shows slower revenue & implementing targeted promotions in January and February could help maintain the momentum built in Q4 2025. (Query2)

*/