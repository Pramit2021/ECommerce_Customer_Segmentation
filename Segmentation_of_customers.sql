-- Segment customers into High Spenders, Medium Spenders, and Low Spenders
SELECT CustomerID,
       SUM(Quantity * UnitPrice) AS TotalSpent,
       CASE
           WHEN SUM(Quantity * UnitPrice) > 10000 THEN 'High Spenders'
           WHEN SUM(Quantity * UnitPrice) BETWEEN 5000 AND 10000 THEN 'Medium Spenders'
           ELSE 'Low Spenders'
       END AS SpendingCategory
FROM customer_data
GROUP BY CustomerID
ORDER BY TotalSpent DESC;


-- Segment customers based on the number of purchases
SELECT 
    CustomerID,
    COUNT(InvoiceNo) AS PurchaseFrequency,
    CASE
        WHEN COUNT(InvoiceNo) > 50 THEN 'Frequent Buyers'
        WHEN COUNT(InvoiceNo) BETWEEN 10 AND 50 THEN 'Occasional Buyers'
        ELSE 'Rare Buyers'
    END AS FrequencySegment
FROM customer_data
GROUP BY CustomerID
ORDER BY PurchaseFrequency DESC;

-- Segment customers based on geographic location
SELECT 
    Country,
    COUNT(DISTINCT CustomerID) AS NumCustomers,
    SUM(Quantity * UnitPrice) AS TotalSpent
FROM customer_data
GROUP BY Country
ORDER BY TotalSpent DESC
LIMIT 10;

-- Combine spending, frequency, and engagement metrics for more detailed segmentation
SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalSpent,
    COUNT(InvoiceNo) AS PurchaseFrequency,
    MAX(InvoiceDate) AS LastPurchaseDate,
    DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS DaysSinceLastPurchase,
    CASE
        WHEN SUM(Quantity * UnitPrice) > 10000 THEN 'High Spenders'
        WHEN SUM(Quantity * UnitPrice) BETWEEN 5000 AND 10000 THEN 'Medium Spenders'
        ELSE 'Low Spenders'
    END AS SpendingSegment,
    CASE
        WHEN COUNT(InvoiceNo) > 50 THEN 'Frequent Buyers'
        WHEN COUNT(InvoiceNo) BETWEEN 10 AND 50 THEN 'Occasional Buyers'
        ELSE 'Rare Buyers'
    END AS FrequencySegment
FROM customer_data
GROUP BY CustomerID
ORDER BY TotalSpent DESC;


-- Recency (Days since last purchase)
SELECT CustomerID, 
       DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS Recency
FROM customer_data
GROUP BY CustomerID;

-- Frequency (Total number of purchases)
SELECT CustomerID, 
       COUNT(DISTINCT InvoiceNo) AS Frequency
FROM customer_data
GROUP BY CustomerID;

-- Monetary Value (Total spend per customer)
SELECT CustomerID, 
       SUM(Quantity * UnitPrice) AS MonetaryValue
FROM customer_data
GROUP BY CustomerID;

-- Full RFM Analysis
SELECT CustomerID, 
       DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS Recency,
       COUNT(DISTINCT InvoiceNo) AS Frequency,
       SUM(Quantity * UnitPrice) AS MonetaryValue
FROM customer_data
GROUP BY CustomerID;

-- Segment customers by how frequently they make purchases: Frequent buyers, Occasional buyers, Rare buyers
SELECT CustomerID, 
       COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
       CASE 
           WHEN COUNT(DISTINCT InvoiceNo) > 10 THEN 'Frequent Buyers'
           WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 5 AND 10 THEN 'Occasional Buyers'
           ELSE 'Rare Buyers'
       END AS BuyerCategory
FROM customer_data
GROUP BY CustomerID;

-- Segment Customers by Lifetime Value (CLV)
SELECT CustomerID, 
       SUM(Quantity * UnitPrice) AS LifetimeValue,
       CASE 
           WHEN SUM(Quantity * UnitPrice) > 10000 THEN 'High CLV'
           WHEN SUM(Quantity * UnitPrice) BETWEEN 5000 AND 10000 THEN 'Medium CLV'
           ELSE 'Low CLV'
       END AS CLVCategory
FROM customer_data
GROUP BY CustomerID;

-- Segment Customers by Product Categories
SELECT CustomerID, 
       StockCode, 
       COUNT(Quantity) AS PurchaseCount
FROM customer_data
GROUP BY CustomerID, StockCode
ORDER BY PurchaseCount DESC;

-- Customers who return products frequently
SELECT CustomerID, 
       COUNT(Quantity) AS ReturnsCount
FROM customer_data
WHERE Quantity < 0
GROUP BY CustomerID
ORDER BY ReturnsCount DESC;

-- Customers with high return rates
SELECT CustomerID, 
       SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) / COUNT(InvoiceNo) AS ReturnRate
FROM customer_data
GROUP BY CustomerID
HAVING ReturnRate > 0.2;

-- Segment customers by time of purchase
SELECT CustomerID,
       InvoiceNo,
       InvoiceDate,
       CASE 
           WHEN HOUR(InvoiceDate) BETWEEN 6 AND 11 THEN 'Morning'
           WHEN HOUR(InvoiceDate) BETWEEN 12 AND 17 THEN 'Afternoon'
           WHEN HOUR(InvoiceDate) BETWEEN 18 AND 21 THEN 'Evening'
           ELSE 'Night'
       END AS TimeOfPurchaseSegment
FROM customer_data;


-- Segment by Location
SELECT Country, 
       COUNT(DISTINCT CustomerID) AS NumberOfCustomers
FROM customer_data
GROUP BY Country
ORDER BY NumberOfCustomers DESC;

-- You can also segment by sales performance in each country:
SELECT Country, 
       SUM(Quantity * UnitPrice) AS TotalRevenue
FROM customer_data
GROUP BY Country
ORDER BY TotalRevenue DESC;

-- Segment by Seasonal Behavior
SELECT CustomerID, 
       MONTH(InvoiceDate) AS PurchaseMonth, 
       COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM customer_data
GROUP BY CustomerID, PurchaseMonth
ORDER BY PurchaseMonth;

-- Segmenting by quarter
SELECT CustomerID, 
       QUARTER(InvoiceDate) AS PurchaseQuarter, 
       COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM customer_data
GROUP BY CustomerID, PurchaseQuarter
ORDER BY PurchaseQuarter;

-- Segment by Average Purchase Value
SELECT CustomerID, 
       AVG(Quantity * UnitPrice) AS AvgOrderValue,
       CASE
           WHEN AVG(Quantity * UnitPrice) > 500 THEN 'High Value'
           WHEN AVG(Quantity * UnitPrice) BETWEEN 100 AND 500 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS ValueSegment
FROM customer_data
GROUP BY CustomerID
ORDER BY AvgOrderValue DESC;

-- Identify first-time purchases
SELECT CustomerID, 
       MIN(InvoiceDate) AS FirstPurchaseDate
FROM customer_data
GROUP BY CustomerID;

-- Segment new vs returning customers
SELECT CustomerID, 
       COUNT(DISTINCT InvoiceNo) AS PurchaseCount,
       CASE 
           WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'New Customer'
           ELSE 'Returning Customer'
       END AS CustomerType
FROM customer_data
GROUP BY CustomerID;