/* This is a made up dataset from Chandoo.org. 
It contains data about a fictional company named Awesome chocolates. */


/* Print details of shipments (sales) where amount are > 2000 and boxes < than 100 */
SELECT Amount, Boxes
FROM sales
WHERE Amount > 2000 and Boxes < 100;

/* How many shipments (sales) each of the salepersons had in the month of January 2022? */
SELECT  Salesperson, MonthName, 
		EXTRACT( YEAR FROM saledate) AS Year_January,
		COUNT(Amount) AS Total_Shipments
FROM people p 
JOIN sales s ON p.spid = s.spid
WHERE  YEAR (saledate) = 2022 AND MonthName = 'January' 
GROUP BY 1, 2, 3
ORDER BY Total_Shipments DESC;

/* Which product sells more boxes? 'Milk bars'or 'Eclairs' ? */
SELECT Product, SUM(boxes) AS Total_Sold
FROM products pr
JOIN sales s ON pr.pid = s.pid
WHERE Product IN ('Milk Bars', 'Eclairs')
GROUP BY 1 
ORDER BY SUM(boxes) DESC;

/* Which product sold more boxes in the first 7 days of February 2022? 'Milk bars'or 'Eclairs' ? */
SELECT Product, SUM(boxes) AS Total_Sold
FROM products pr
JOIN sales s ON pr.pid = s.pid
WHERE Product IN ('Milk Bars', 'Eclairs')
AND SaleDate BETWEEN '2022-02-01' AND '2022-02-07'
GROUP BY 1
ORDER BY SUM(boxes) DESC;

/* Which shipments had under 100 < customers and under 100 < boxes? did any of them occur on a wednesday ?
---------ON MYSQL WORKBENCH A WEEK STARTS OF A SUNDAY WHICH = 1  --- SO WEDNESDAY = 4------------
 */
SELECT  Product, Customers, Boxes,
		CASE 
			WHEN WEEKDAY(SaleDate) = 4 THEN 'WEDNESDAY'
            ELSE 'OTHER_DAY'
            END AS Day_Of_The_week
FROM sales S 
JOIN products PR ON S.PID = PR.PID
WHERE Customers < 100 AND Boxes < 100;
 
/* What are the names of salespersons who had atleast one shipment in the first 7 days of January 2022? */
SELECT DISTINCT P.Salesperson
FROM people P
WHERE P.SPID IN ( SELECT DISTINCT S.SPID FROM sales S WHERE S.SaleDate BETWEEN '2022-01-01' AND '2022-01-07');

/* Which salespersons did not make any shipments in the first 7 days of January 2022? */
SELECT DISTINCT P.Salesperson
FROM people P
WHERE P.SPID NOT IN ( SELECT DISTINCT S.SPID FROM sales S WHERE S.SaleDate BETWEEN '2022-01-01' AND '2022-01-07');

/* How many times we shipped more than 1000 boxes in each month? */ 
SELECT MonthName, COUNT(*) 
FROM sales
WHERE Boxes > 1000
GROUP BY 1;

/* Did we ship atleast one box of 'After Nines' to 'New Zealand' on all the months? */ 
SELECT YEAR(SaleDate), MONTHNAME(SaleDate), PR.Product,
		IF (SUM(S.Boxes) > 1, "Yes", "No" ) AS IF_SHIPPED
FROM sales S
JOIN products PR ON S.PID = PR.PID
JOIN geo G ON S.GeoID = G.GeoID
WHERE PR.Product = 'After Nines' AND Geo = 'New Zealand'
GROUP BY 1, 2;

/* India or Australia ? Who buys more chocolates on a monthly basis? */
SELECT YEAR(SALEDATE), MONTHNAME(SALEDATE),
			SUM( CASE WHEN G.geo = 'India' = 1 THEN Boxes ELSE 0 END) AS India_boxes,
			SUM( CASE WHEN G.geo = 'australia' = 1 THEN Boxes ELSE 0 END ) AS Australia_boxes
FROM sales S
JOIN geo G ON S.GeoID = G.GeoID
JOIN products PR ON PR.PID = S.PID
GROUP BY 1, 2;
