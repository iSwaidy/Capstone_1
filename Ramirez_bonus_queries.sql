/* 
Cris Ramirez
04/30/2026            -- Assigned Manger: Shruti Reddy                       
Capstone 01           -- Territory: Maryland
*/

USE sample_sales;
SHOW TABLES;

-- BONUS Q16: Display total revenue by regional director

SELECT RegionalDirector,
	CONCAT('$', FORMAT(SUM(sale_amount), 2)) AS 'Total Revenue'
FROM store_sales ss
JOIN store_locations sl ON ss.store_id = sl.storeid
JOIN management m ON sl.State = m.State 
GROUP BY RegionalDirector 
ORDER BY SUM(Sale_Amount) DESC;