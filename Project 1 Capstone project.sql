--THESE QUERIES WERE RUN IN POSTGRES VERSION 17
CREATE DATABASE CapstoneProject;

CREATE TABLE SalesData (
    OrderID INTEGER PRIMARY KEY,
    CustomerID VARCHAR(10),
    Product VARCHAR(250),
    Region VARCHAR(50),
    OrderDate DATE,
    Quantity INTEGER,
    UnitPrice DECIMAL(10, 2)
);

--1: Total Sales by Product Category:--
SELECT Product, SUM(Quantity * UnitPrice) AS TotalSales
FROM SalesData
GROUP BY Product;

--2: Number of Sales Transactions by Region:--
SELECT Region, COUNT(OrderID) AS Transactions
FROM SalesData
GROUP BY Region;

--3: Highest-Selling Product by Total Sales Value:--
SELECT Product, SUM(Quantity * UnitPrice) AS TotalSales
FROM SalesData
GROUP BY Product
ORDER BY TotalSales DESC LIMIT 1;

--4: Total Revenue per Product:--
SELECT Product, SUM(Quantity * UnitPrice) AS Revenue
FROM SalesData
GROUP BY Product;

--5: Calculate monthly sales totals for the current year--
SELECT TO_CHAR(OrderDate, 'MM-YYYY') AS Month, 
       SUM(Quantity * UnitPrice) AS MonthlySales
FROM SalesData
WHERE EXTRACT(YEAR FROM OrderDate) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY TO_CHAR(OrderDate, 'MM-YYYY')
ORDER BY Month;

--6: find the top 5 customers by total purchase amount.--
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalPurchase
FROM SalesData
GROUP BY CustomerID
ORDER BY TotalPurchase DESC
LIMIT 5;

--7: calculate the percentage of total sales contributed by each region. --
WITH RegionalSales AS (
    SELECT Region, SUM(Quantity * UnitPrice) AS TotalSales
    FROM SalesData
    GROUP BY Region
)
SELECT Region, TotalSales, 
       (TotalSales * 100.0 / (SELECT SUM(TotalSales) FROM RegionalSales)) AS SalesPercentage
FROM RegionalSales;

--8: identify products with no sales in the last quarter.--
SELECT DISTINCT Product
FROM SalesData
WHERE OrderDate < CURRENT_DATE - INTERVAL '3 months'
  AND Product NOT IN (
      SELECT Product 
      FROM SalesData
      WHERE OrderDate >= CURRENT_DATE - INTERVAL '3 months'
  );