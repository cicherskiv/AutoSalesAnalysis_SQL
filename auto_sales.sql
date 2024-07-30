--SQLite 
--KPIs
--num of total orders
--total revenue
--avg time between orders
--bestselling productline 



--charts
--top 5 countries
--% sales per deal size
--month w most sales
SELECT * FROM Auto_Sales_data asd 


--top 5 countries in order frequency (#1 is US)
SELECT COUNTRY, COUNT(DISTINCT ORDERNUMBER) FROM Auto_Sales_data
GROUP BY COUNTRY
ORDER BY COUNT(DISTINCT ORDERNUMBER) DESC LIMIT 5


--percent of sales of each deal size
SELECT DEALSIZE, ROUND(SUM(SALES) *100 / (SELECT SUM(SALES) FROM Auto_Sales_data), 2) AS percent_sales
FROM Auto_Sales_data
GROUP BY DEALSIZE 

--number of total orders
SELECT SUM(DISTINCT ORDERNUMBER) FROM Auto_Sales_data asd 



--ADD col with the event month
ALTER TABLE Auto_Sales_data

UPDATE Auto_Sales_data
SET EventMonth = CASE substr(ORDERDATE, 4, 2)
           WHEN '01' THEN 'January'
           WHEN '02' THEN 'February'
           WHEN '03' THEN 'March'
           WHEN '04' THEN 'April'
           WHEN '05' THEN 'May'
           WHEN '06' THEN 'June'
           WHEN '07' THEN 'July'
           WHEN '08' THEN 'August'
           WHEN '09' THEN 'September'
           WHEN '10' THEN 'October'
           WHEN '11' THEN 'November'
           WHEN '12' THEN 'December'
           ELSE 'Unknown'
END


SELECT * FROM Auto_Sales_data
--months w most sales
SELECT EventMonth, SUM(sales)
FROM Auto_Sales_data
GROUP BY EventMonth
ORDER BY SUM(sales) DESC

--avg time between orders
SELECT SUM(DAYS_SINCE_LASTORDER) / COUNT(DAYS_SINCE_LASTORDER) As avg_time FROM Auto_Sales_data 
ORDER BY avg_time ASC

--in both rev and quantity, classic cars are besst
SELECT PRODUCTLINE, SUM(sales) FROM Auto_Sales_data asd 
GROUP BY PRODUCTLINE 
ORDER BY SUM(sales) DESC

SELECT PRODUCTLINE, SUM(QUANTITYORDERED) FROM Auto_Sales_data asd 
GROUP BY PRODUCTLINE
ORDER BY SUM(QUANTITYORDERED) DESC

--top selling product codes

SELECT PRODUCTLINE, PRODUCTCODE, TotalQuantity
FROM (
    SELECT PRODUCTLINE, PRODUCTCODE, SUM(QUANTITYORDERED) AS TotalQuantity
    FROM Auto_Sales_data
    GROUP BY PRODUCTLINE, PRODUCTCODE
) AS ProductTotals
WHERE TotalQuantity = (
    SELECT MAX(TotalQuantity)
    FROM (
        SELECT PRODUCTLINE, SUM(QUANTITYORDERED) AS TotalQuantity
        FROM Auto_Sales_data
        WHERE PRODUCTLINE = ProductTotals.PRODUCTLINE
        GROUP BY PRODUCTCODE
    )
)

--everybody is a repeat customer
SELECT CUSTOMERNAME, COUNT(ORDERNUMBER) FROM Auto_Sales_data asd 
GROUP BY CUSTOMERNAME 
ORDER BY COUNT(ORDERNUMBER) DESC

SELECT COUNT(DISTINCT CUSTOMERNAME) FROM Auto_Sales_data asd 

--total revenue
SELECT SUM(sales) FROM Auto_Sales_data asd 



--takeways: only 90 customers but they are all loyal with repeat sales 
--89/89 are repeat customers
