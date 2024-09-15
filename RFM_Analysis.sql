-- Calculate the number of days since the last purchase for each customer.
SELECT CustomerID, 
       DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS Recency
FROM customer_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;


-- Count how many distinct invoices (purchases) each customer has made.
SELECT CustomerID, 
       COUNT(DISTINCT InvoiceNo) AS Frequency
FROM customer_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;


-- Calculate the total amount of money spent by each customer
SELECT CustomerID, 
       SUM(Quantity * UnitPrice) AS Monetary
FROM customer_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;


-- Combine the above queries using Common Table Expressions (CTEs) or by joining subqueries
WITH Recency AS (
    SELECT CustomerID, 
           DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS Recency
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
Frequency AS (
    SELECT CustomerID, 
           COUNT(DISTINCT InvoiceNo) AS Frequency
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
Monetary AS (
    SELECT CustomerID, 
           SUM(Quantity * UnitPrice) AS Monetary
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT r.CustomerID, 
       r.Recency, 
       f.Frequency, 
       m.Monetary
FROM Recency r
JOIN Frequency f ON r.CustomerID = f.CustomerID
JOIN Monetary m ON r.CustomerID = m.CustomerID;


WITH RecencyRank AS (
    SELECT CustomerID,
           DATEDIFF(CURDATE(), MAX(InvoiceDate)) AS Recency,
           NTILE(5) OVER (ORDER BY DATEDIFF(CURDATE(), MAX(InvoiceDate))) AS RecencyScore
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
FrequencyRank AS (
    SELECT CustomerID,
           COUNT(DISTINCT InvoiceNo) AS Frequency,
           NTILE(5) OVER (ORDER BY COUNT(DISTINCT InvoiceNo) DESC) AS FrequencyScore
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
MonetaryRank AS (
    SELECT CustomerID,
           SUM(Quantity * UnitPrice) AS Monetary,
           NTILE(5) OVER (ORDER BY SUM(Quantity * UnitPrice) DESC) AS MonetaryScore
    FROM customer_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT r.CustomerID,
       r.Recency,
       r.RecencyScore,
       f.Frequency,
       f.FrequencyScore,
       m.Monetary,
       m.MonetaryScore,
       CONCAT(r.RecencyScore, f.FrequencyScore, m.MonetaryScore) AS RFMScore
FROM RecencyRank r
JOIN FrequencyRank f ON r.CustomerID = f.CustomerID
JOIN MonetaryRank m ON r.CustomerID = m.CustomerID
ORDER BY RFMScore DESC;