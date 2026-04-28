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

-- Check Shipper ist table
SELECT * FROM shipper_list
WHERE ShiptoState = 'Maryland';

-- Check Store Locations table
SELECT * FROM store_locations
WHERE State = 'Maryland';

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
