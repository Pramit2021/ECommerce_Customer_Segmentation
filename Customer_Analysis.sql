-- Inspecting data
SELECT * FROM customer_data;

-- Checking unique values
SELECT DISTINCT CustomerID FROM customer_data;
SELECT DISTINCT YEAR(InvoiceDate) FROM customer_data;
SELECT DISTINCT Country FROM customer_data;
SELECT DISTINCT StockCode, Description FROM customer_data GROUP BY StockCode, Description;

-- Identify your top customers in terms of revenue
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpent
FROM customer_data
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;
-- RESULT: The Customer with CustomerID 14646 has highest revenue.

-- Find out which countries contribute the most to your revenue.
SELECT Country, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM customer_data
GROUP BY Country
ORDER BY TotalRevenue DESC
LIMIT 10;
-- United Kingdom has the highest contribution to the revenue


-- Identify which countries have the highest customer base.
SELECT Country, COUNT(DISTINCT CustomerID) AS NumberOfCustomers
FROM customer_data
GROUP BY Country
ORDER BY NumberOfCustomers DESC;
-- RESULT: United Kingdom has the highest number of customers.


-- Identify the most purchased products based on Quantity.
SELECT StockCode, Description, SUM(Quantity) AS TotalSold
FROM customer_data
GROUP BY StockCode, Description
ORDER BY TotalSold DESC;
-- RESULT: The most purchased product is WORLD WAR 2 GLUIDERS ASSTD DESIGNS.


-- Identify which products contribute the most to revenue.
SELECT StockCode, Description, SUM(Quantity*UnitPrice) AS TotalRevenue
FROM customer_data
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC;
-- RESULT: The product with highest contribution to total revenue is REGENCY CAKESTAND 3 TEIR


-- Count how many purchases each customer has made.
SELECT CustomerID, COUNT(InvoiceNo) AS PurchaseFrequency
FROM customer_data
GROUP BY CustomerID
ORDER BY PurchaseFrequency DESC;
-- RESULT: The Customer with CustomerID 17841 has highest purchase frequency

-- Track revenue over time to identify trends and seasonal variations.
SELECT MONTH(InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS MonthlyRevenue
FROM customer_data
GROUP BY Month
ORDER BY MonthlyRevenue DESC
LIMIT 10;
-- RESULT: Revenue was highest in month November.


-- Identify how many customers made repeat purchases by counting unique customers and comparing them with the number of unique invoices.
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM customer_data
GROUP BY CustomerID
HAVING PurchaseCount > 1 
ORDER BY PurchaseCount DESC;
-- RESULT: The most frequent customer has CustomerID 14911


-- Identify which days or months generate the most sales.
SELECT DAYNAME(InvoiceDate) AS DayOfWeek, SUM(Quantity * UnitPrice) AS DailyRevenue
FROM customer_data
GROUP BY DayOfWeek
ORDER BY DailyRevenue DESC;
-- RESULT: The day with highest revenue is Tuesday.

-- Which is the most selling product in United Kingdom ?
SELECT StockCode, Description, SUM(Quantity*UnitPrice) AS TotalRevenue
FROM customer_data
WHERE Country = 'United Kingdom'
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC
LIMIT 10;
-- RESULT: The most selling product in United Kingdom is REGENCY CAKESTAND 3 TIER