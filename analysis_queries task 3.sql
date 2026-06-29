/* =====================================================================
   PROJECT 3: SQL DATA ANALYSIS
   Dataset : orders (1,200 e-commerce orders, Jan 2023 - Jun 2025)
   Goal    : Use SQL queries to extract insights from the dataset
   ===================================================================== */


/* ---------------------------------------------------------------------
   SECTION 1 — SELECT QUERIES
   --------------------------------------------------------------------- */

-- 1.1 Preview the raw data
SELECT *
FROM orders
LIMIT 10;

-- 1.2 Select only the columns needed for a sales view
SELECT OrderID, Date, Product, Quantity, UnitPrice, TotalPrice
FROM orders
LIMIT 10;

-- 1.3 List the distinct products sold
SELECT DISTINCT Product
FROM orders;


/* ---------------------------------------------------------------------
   SECTION 2 — FILTERING WITH WHERE
   --------------------------------------------------------------------- */

-- 2.1 High-value orders (over $2,000)
SELECT OrderID, Product, Quantity, TotalPrice, OrderStatus
FROM orders
WHERE TotalPrice > 2000;

-- 2.2 Delivered Laptop orders only
SELECT OrderID, Date, CustomerID, Quantity, TotalPrice
FROM orders
WHERE Product = 'Laptop' AND OrderStatus = 'Delivered';

-- 2.3 Orders that were Cancelled or Returned (lost revenue)
SELECT OrderID, Product, TotalPrice, OrderStatus
FROM orders
WHERE OrderStatus IN ('Cancelled', 'Returned');

-- 2.4 Orders placed without any coupon
SELECT OrderID, Product, TotalPrice
FROM orders
WHERE CouponCode IS NULL;


/* ---------------------------------------------------------------------
   SECTION 3 — SORTING WITH ORDER BY
   --------------------------------------------------------------------- */

-- 3.1 Top 10 highest-value orders
SELECT OrderID, Product, CustomerID, TotalPrice
FROM orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- 3.2 Most recent 10 orders
SELECT OrderID, Date, Product, TotalPrice
FROM orders
ORDER BY Date DESC
LIMIT 10;

-- 3.3 Cheapest 10 orders
SELECT OrderID, Product, TotalPrice
FROM orders
ORDER BY TotalPrice ASC
LIMIT 10;


/* ---------------------------------------------------------------------
   SECTION 4 — GROUP BY & AGGREGATIONS (COUNT, SUM, AVG)
   --------------------------------------------------------------------- */

-- 4.1 Orders, revenue, and average order value PER PRODUCT
SELECT
    Product,
    COUNT(*)            AS NumOrders,
    SUM(TotalPrice)      AS TotalRevenue,
    ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 4.2 Order count PER STATUS (Delivered/Shipped/Cancelled/...)
SELECT
    OrderStatus,
    COUNT(*) AS NumOrders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 1) AS PctOfOrders
FROM orders
GROUP BY OrderStatus
ORDER BY NumOrders DESC;

-- 4.3 Revenue PER PAYMENT METHOD
SELECT
    PaymentMethod,
    COUNT(*)            AS NumOrders,
    SUM(TotalPrice)      AS TotalRevenue,
    ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY PaymentMethod
ORDER BY TotalRevenue DESC;

-- 4.4 Performance PER REFERRAL SOURCE (marketing channel)
SELECT
    ReferralSource,
    COUNT(*)            AS NumOrders,
    SUM(TotalPrice)      AS TotalRevenue,
    ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY ReferralSource
ORDER BY TotalRevenue DESC;

-- 4.5 Monthly revenue trend
SELECT
    strftime('%Y-%m', Date) AS Month,
    COUNT(*)                AS NumOrders,
    SUM(TotalPrice)          AS Revenue
FROM orders
GROUP BY Month
ORDER BY Month;

-- 4.6 Top 10 customers by total spend (repeat-customer analysis)
SELECT
    CustomerID,
    COUNT(*)            AS NumOrders,
    SUM(TotalPrice)      AS TotalSpent
FROM orders
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;

-- 4.7 Customers who placed MORE THAN ONE order (GROUP BY + HAVING)
SELECT
    CustomerID,
    COUNT(*) AS NumOrders,
    SUM(TotalPrice) AS TotalSpent
FROM orders
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY NumOrders DESC;

-- 4.8 Coupon usage and its effect on revenue
SELECT
    COALESCE(CouponCode, 'No Coupon') AS Coupon,
    COUNT(*)            AS NumOrders,
    SUM(TotalPrice)      AS TotalRevenue,
    ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY Coupon
ORDER BY NumOrders DESC;

-- 4.9 Average quantity & unit price PER PRODUCT
SELECT
    Product,
    ROUND(AVG(Quantity), 2)  AS AvgQuantity,
    ROUND(AVG(UnitPrice), 2) AS AvgUnitPrice
FROM orders
GROUP BY Product
ORDER BY AvgUnitPrice DESC;

-- 4.10 Revenue by Product AND Status combined (multi-column GROUP BY)
SELECT
    Product,
    OrderStatus,
    COUNT(*)       AS NumOrders,
    SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY Product, OrderStatus
ORDER BY Product, Revenue DESC;
