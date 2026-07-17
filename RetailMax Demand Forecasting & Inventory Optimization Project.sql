-- 1. Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS retailmax_db;
USE retailmax_db;

-- 2. Create the clean target table
CREATE TABLE IF NOT EXISTS sales_data (
    SaleID INT PRIMARY KEY,
    Sales_Date VARCHAR(15),       -- We import as VARCHAR first to safely handle date conversion
    Store VARCHAR(20),
    Region VARCHAR(15),
    ProductCategory VARCHAR(25),
    ProductName VARCHAR(30),
    UnitsSold INT,
    UnitPrice DECIMAL(10, 2),
    Revenue DECIMAL(12, 2),
    InventoryLevel INT,
    Promotion VARCHAR(5),
    HolidayFlag VARCHAR(5),
    Weather VARCHAR(15),
    CustomerTraffic INT,
    Year INT,
    Month INT,
    Quarter INT,
    DayName VARCHAR(15),
    DayOfTheYear INT,
    InventoryStatus VARCHAR(20)
);

Select*
From retailmax_demand_forecasting_cleean_dataset;

-- TOTAL BUSINESS REVENUE
-- Business Question:
-- How much revenue has RetailMax generated across all sales transactions?
--
-- Why it matters:
-- Provides the top-line performance metric for the business.

SELECT
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset;

-- TOTAL UNITS SOLD
-- Business Question:
-- How many products have been sold across all stores?
--
-- Why it matters:
-- Measures overall demand volume.

SELECT
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset;

-- AVERAGE TRANSACTION VALUE
-- Business Question:
-- What is the average revenue generated per transaction?
--
-- Why it matters:
-- Helps evaluate customer purchasing behavior.

SELECT
    ROUND(AVG(Revenue), 2) AS AvgTransactionValue
FROM retailmax_demand_forecasting_cleean_dataset;

-- REVENUE BY STORE
-- Business Question:
-- Which stores generate the highest revenue?
--
-- Why it matters:
-- Helps identify top-performing locations.

SELECT
    Store,
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Store
ORDER BY TotalRevenue DESC;

-- REVENUE BY PRODUCT CATEGORY
-- Business Question:
-- Which product categories drive business revenue?
--
-- Why it matters:
-- Helps prioritize product investments.

SELECT
    ProductCategory,
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductCategory
ORDER BY TotalRevenue DESC;

-- REVENUE CONTRIBUTION BY CATEGORY
-- Business Question:
-- What percentage of total revenue comes from each category?
--
-- Why it matters:
-- Shows category dependence and diversification.

SELECT
    ProductCategory,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(
        SUM(Revenue) * 100 /
        (SELECT SUM(Revenue)
         FROM retailmax_demand_forecasting_cleean_dataset),
        2
    ) AS RevenuePercentage
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductCategory
ORDER BY Revenue DESC;

-- TOP 10 PRODUCTS BY REVENUE
-- Business Question:
-- Which individual products generate the most revenue?
--
-- Why it matters:
-- Identifies star-performing products.

SELECT
    ProductName,
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductName
ORDER BY TotalRevenue DESC
LIMIT 10;

-- BOTTOM 10 PRODUCTS BY REVENUE
-- Business Question:
-- Which products contribute the least revenue?
--
-- Why it matters:
-- Helps identify underperforming inventory.

SELECT
    ProductName,
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductName
ORDER BY TotalRevenue ASC
LIMIT 10;

-- MONTHLY REVENUE TREND
-- Business Question:
-- How does revenue change throughout the year?
--
-- Why it matters:
-- Reveals seasonality patterns.

SELECT
    Year,
    Month,
    ROUND(SUM(Revenue), 2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Year, Month
ORDER BY Year, Month;

-- BEST-SELLING PRODUCTS BY UNITS SOLD
-- Business Question:
-- Which products have the highest demand?
--
-- Why it matters:
-- Identifies products customers purchase most frequently.

SELECT
    ProductName,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductName
ORDER BY TotalUnitsSold DESC
LIMIT 10;

-- LOWEST-DEMAND PRODUCTS
-- Business Question:
-- Which products sell the fewest units?
--
-- Why it matters:
-- Helps identify slow-moving inventory.

SELECT
    ProductName,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductName
ORDER BY TotalUnitsSold ASC
LIMIT 10;

-- PRODUCT CATEGORY DEMAND
-- Business Question:
-- Which categories sell the highest volume of units?
--
-- Why it matters:
-- Revenue can be driven by high prices, but demand reveals customer preferences.

SELECT
    ProductCategory,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductCategory
ORDER BY TotalUnitsSold DESC;

-- AVERAGE REVENUE PER UNIT BY CATEGORY
-- Business Question:
-- Which categories generate the most revenue per item sold?
--
-- Why it matters:
-- Helps distinguish premium categories from high-volume categories.

SELECT
    ProductCategory,
    ROUND(SUM(Revenue) / SUM(UnitsSold),2) AS RevenuePerUnit
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductCategory
ORDER BY RevenuePerUnit DESC;

-- TOP PRODUCTS WITHIN EACH CATEGORY
-- Business Question:
-- Which products are category leaders?
--
-- Why it matters:
-- Helps identify flagship products.

WITH ProductRanking AS (
    SELECT
        ProductCategory,
        ProductName,
        ROUND(SUM(Revenue),2) AS Revenue,
        RANK() OVER(
            PARTITION BY ProductCategory
            ORDER BY SUM(Revenue) DESC
        ) AS ProductRank
    FROM retailmax_demand_forecasting_cleean_dataset
    GROUP BY ProductCategory, ProductName
)
SELECT *
FROM ProductRanking
WHERE ProductRank <= 3
ORDER BY ProductCategory, ProductRank;

-- STORE PRODUCT SPECIALIZATION
-- Business Question:
-- Which products drive the most revenue at each store?
--
-- Why it matters:
-- Helps understand local demand patterns.

WITH StoreProductRevenue AS (
    SELECT
        Store,
        ProductName,
        ROUND(SUM(Revenue),2) AS Revenue,
        RANK() OVER(
            PARTITION BY Store
            ORDER BY SUM(Revenue) DESC
        ) AS RevenueRank
    FROM retailmax_demand_forecasting_cleean_dataset
    GROUP BY Store, ProductName
)
SELECT *
FROM StoreProductRevenue
WHERE RevenueRank <= 3
ORDER BY Store, RevenueRank;

-- INVENTORY STATUS DISTRIBUTION
-- Business Question:
-- How many records fall into Low Stock, Normal, and Overstock?
--
-- Why it matters:
-- Provides an overall inventory health assessment.

SELECT
    InventoryStatus,
    COUNT(*) AS RecordsCount
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY InventoryStatus
ORDER BY RecordsCount DESC;

-- PRODUCTS MOST FREQUENTLY IN LOW STOCK STATUS
-- Business Question:
-- Which products are most often at risk of stockouts?
--
-- Why it matters:
-- Identifies products requiring improved replenishment planning.

SELECT
    ProductName,
    COUNT(*) AS LowStockOccurrences
FROM retailmax_demand_forecasting_cleean_dataset
WHERE InventoryStatus = 'Low Stock'
GROUP BY ProductName
ORDER BY LowStockOccurrences DESC
LIMIT 10;

-- PRODUCTS MOST FREQUENTLY OVERSTOCKED
-- Business Question:
-- Which products are overstocked most often?
--
-- Why it matters:
-- Highlights inventory carrying-cost risks.

SELECT
    ProductName,
    COUNT(*) AS OverstockOccurrences
FROM retailmax_demand_forecasting_cleean_dataset
WHERE InventoryStatus = 'Overstock'
GROUP BY ProductName
ORDER BY OverstockOccurrences DESC
LIMIT 20;

-- INVENTORY RISK BY CATEGORY
-- Business Question:
-- Which categories experience the most stock shortages?
--
-- Why it matters:
-- Supports category-level inventory planning.

SELECT
    ProductCategory,
    COUNT(*) AS LowStockEvents
FROM retailmax_demand_forecasting_cleean_dataset
WHERE InventoryStatus = 'Low Stock'
GROUP BY ProductCategory
ORDER BY LowStockEvents DESC;

-- PRODUCTS MOST FREQUENTLY OVERSTOCKED
-- Business Question:
-- Which products are overstocked most often?
--
-- Why it matters:
-- Highlights inventory carrying-cost risks.

SELECT
    ProductName,
    COUNT(*) AS OverstockOccurrences
FROM retailmax_demand_forecasting_cleean_dataset
WHERE InventoryStatus = 'Over Stock'
GROUP BY ProductName
ORDER BY OverstockOccurrences DESC
LIMIT 10;

-- HIGH-DEMAND PRODUCTS WITH LOW INVENTORY
-- Business Question:
-- Which products combine strong sales with relatively low inventory?
--
-- Why it matters:
-- These products may face stockout risks.

SELECT
    ProductName,
    SUM(UnitsSold) AS TotalDemand,
    ROUND(AVG(InventoryLevel),2) AS AvgInventory
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY ProductName
HAVING AvgInventory < 200
ORDER BY TotalDemand DESC
LIMIT 15;

-- PROMOTION VS NON-PROMOTION REVENUE
-- Business Question:
-- Do promotions generate more revenue?
--
-- Why it matters:
-- Measures the effectiveness of promotional campaigns.

SELECT
    Promotion,
    ROUND(SUM(Revenue),2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Promotion;

-- PROMOTION VS NON-PROMOTION UNITS SOLD
-- Business Question:
-- Do promotions increase product demand?
--
-- Why it matters:
-- Determines whether promotions drive volume growth.

SELECT
    Promotion,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Promotion;

-- AVERAGE TRANSACTION VALUE BY PROMOTION STATUS
-- Business Question:
-- Do customers spend more during promotions?
--
-- Why it matters:
-- Evaluates promotion quality rather than just volume.

SELECT
    Promotion,
    ROUND(AVG(Revenue),2) AS AvgTransactionValue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Promotion;

-- HOLIDAY VS NON-HOLIDAY REVENUE
-- Business Question:
-- How much impact do holidays have on sales?
--
-- Why it matters:
-- Helps plan inventory and staffing around holidays.

SELECT
    HolidayFlag,
    ROUND(SUM(Revenue),2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY HolidayFlag;

-- HOLIDAY VS NON-HOLIDAY DEMAND
-- Business Question:
-- Are more units sold during holiday periods?
--
-- Why it matters:
-- Measures seasonal demand spikes.

SELECT
    HolidayFlag,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY HolidayFlag;

-- WEATHER IMPACT ON REVENUE
-- Business Question:
-- Which weather conditions generate the highest sales?
--
-- Why it matters:
-- Weather may be a predictive variable for demand forecasting.

SELECT
    Weather,
    ROUND(SUM(Revenue),2) AS TotalRevenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Weather
ORDER BY TotalRevenue DESC;

-- WEATHER IMPACT ON DEMAND
-- Business Question:
-- How does weather affect product demand?
--
-- Why it matters:
-- Supports future demand forecasting models.

SELECT
    Weather,
    SUM(UnitsSold) AS TotalUnitsSold
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Weather
ORDER BY TotalUnitsSold DESC;

-- CUSTOMER TRAFFIC IMPACT
-- Business Question:
-- Is higher store traffic associated with higher revenue?
--
-- Why it matters:
-- Identifies whether traffic is a key sales driver.

SELECT
    CASE
        WHEN CustomerTraffic < 1000 THEN 'Low Traffic'
        WHEN CustomerTraffic BETWEEN 1000 AND 2000 THEN 'Medium Traffic'
        ELSE 'High Traffic'
    END AS TrafficLevel,
    COUNT(*) AS Transactions,
    ROUND(SUM(Revenue),2) AS Revenue
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY TrafficLevel
ORDER BY Revenue DESC;

-- BEST PRODUCTS DURING PROMOTIONS
-- Business Question:
-- Which products benefit most from promotions?
--
-- Why it matters:
-- Helps target future marketing campaigns.

SELECT
    ProductName,
    ROUND(SUM(Revenue),2) AS PromotionRevenue
FROM retailmax_demand_forecasting_cleean_dataset
WHERE Promotion = 'Yes'
GROUP BY ProductName
ORDER BY PromotionRevenue DESC
LIMIT 10;


-- MONTHLY DEMAND TREND
-- Business Question:
-- How does demand change throughout the year?
--
-- Why it matters:
-- Essential for forecasting future inventory requirements.

SELECT
    Year,
    Month,
    SUM(UnitsSold) AS TotalDemand
FROM retailmax_demand_forecasting_cleean_dataset
GROUP BY Year, Month
ORDER BY Year, Month;

-- TOP SELLING PRODUCTS BY WEATHER CONDITION
-- Business Question:
-- Which products generate the highest demand under different weather conditions?
--
-- Why it matters:
-- Helps optimize inventory planning based on weather forecasts.

WITH WeatherProductSales AS (
    SELECT
        Weather,
        ProductName,
        SUM(UnitsSold) AS TotalUnitsSold,
        RANK() OVER (
            PARTITION BY Weather
            ORDER BY SUM(UnitsSold) DESC
        ) AS SalesRank
    FROM retailmax_demand_forecasting_cleean_dataset
    GROUP BY Weather, ProductName
)

SELECT
    Weather,
    ProductName,
    TotalUnitsSold
FROM WeatherProductSales
WHERE SalesRank <= 5
ORDER BY Weather, TotalUnitsSold DESC;

-- TOP PRODUCT CATEGORIES BY WEATHER
-- Business Question:
-- Which categories perform best under each weather condition?
--
-- Why it matters:
-- Supports weather-driven inventory allocation.

WITH WeatherCategorySales AS (
    SELECT
        Weather,
        ProductCategory,
        SUM(UnitsSold) AS TotalUnitsSold,
        RANK() OVER (
            PARTITION BY Weather
            ORDER BY SUM(UnitsSold) DESC
        ) AS CategoryRank
    FROM retailmax_demand_forecasting_cleean_dataset
    GROUP BY Weather, ProductCategory
)

SELECT
    Weather,
    ProductCategory,
    TotalUnitsSold
FROM WeatherCategorySales
WHERE CategoryRank <= 3
ORDER BY Weather, TotalUnitsSold DESC;

-- PRODUCTS GENERATING THE MOST REVENUE IN EACH WEATHER CONDITION
-- Business Question:
-- Which products drive the most revenue under different weather conditions?
--
-- Why it matters:
-- Supports weather-aware forecasting and merchandising decisions.

WITH WeatherRevenue AS (
    SELECT
        Weather,
        ProductName,
        ROUND(SUM(Revenue),2) AS TotalRevenue,
        RANK() OVER (
            PARTITION BY Weather
            ORDER BY SUM(Revenue) DESC
        ) AS RevenueRank
    FROM retailmax_demand_forecasting_cleean_dataset
    GROUP BY Weather, ProductName
)

SELECT
    Weather,
    ProductName,
    TotalRevenue
FROM WeatherRevenue
WHERE RevenueRank <= 5
ORDER BY Weather, TotalRevenue DESC;