CREATE DATABASE IF NOT EXISTS fintrust_analytics;
USE fintrust_analytics;

CREATE TABLE IF NOT EXISTS customer_churn (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(10),
    Age INT,
    Country VARCHAR(50),
    City VARCHAR(50),
    TenureMonths INT,
    AccountType VARCHAR(20),
    ProductsOwned INT,
    MonthlyTransactions INT,
    AverageBalance DECIMAL(15, 2),
    LoanAmount DECIMAL(15, 2),
    CreditCardSpend DECIMAL(15, 2),
    ComplaintsLast12Months INT,
    SupportCallsLast12Months INT,
    MobileAppLogins INT,
    OnlineBankingUsage INT,
    EstimatedAnnualRevenue DECIMAL(15, 2),
    Churn VARCHAR(5)
);

TRUNCATE TABLE customer_churn;
Select*
From customer_churn;

-- TOTAL CUSTOMER BASE
-- Business Question:
-- How many customers does the bank currently serve?
--
-- Why it matters:
-- Establishes the size of the customer portfolio.

SELECT COUNT(*) AS TotalCustomers
FROM customer_churn;

-- CUSTOMER DISTRIBUTION BY COUNTRY
-- Business Question:
-- Which countries represent the largest customer markets?
--
-- Why it matters:
-- Helps identify strategic growth regions.

SELECT
    Country,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY Country
ORDER BY CustomerCount DESC;

-- CUSTOMER DISTRIBUTION BY ACCOUNT TYPE
-- Business Question:
-- Which account products are most popular?
--
-- Why it matters:
-- Supports product strategy decisions.

SELECT
    AccountType,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY AccountType
ORDER BY CustomerCount DESC;


-- CUSTOMER DISTRIBUTION BY GENDER
-- Business Question:
-- What is the gender makeup of the customer base?
--
-- Why it matters:
-- Supports demographic analysis.

SELECT
    Gender,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY Gender;

-- CUSTOMER DISTRIBUTION BY AGE GROUP
-- Business Question:
-- Which age groups dominate the customer base?
--
-- Why it matters:
-- Different age groups exhibit different banking behaviors.

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS AgeGroup,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY AgeGroup
ORDER BY CustomerCount DESC;

-- OVERALL CHURN RATE
-- Business Question:
-- What percentage of customers have churned?
--
-- Why it matters:
-- Measures customer retention performance.

SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn;


-- CHURN RATE BY COUNTRY
-- Business Question:
-- Which markets experience the highest customer loss?
--
-- Why it matters:
-- Enables targeted retention initiatives.

SELECT
    Country,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY Country
ORDER BY ChurnRate DESC;


-- CHURN RATE BY ACCOUNT TYPE
-- Business Question:
-- Which banking products are losing the most customers?
--
-- Why it matters:
-- Highlights vulnerable product lines.

SELECT
    AccountType,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY AccountType
ORDER BY ChurnRate DESC;


-- CHURN RATE BY AGE GROUP
-- Business Question:
-- Which age segments are most likely to leave?
--
-- Why it matters:
-- Supports customer retention strategies.

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS AgeGroup,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY AgeGroup
ORDER BY ChurnRate DESC;

-- REVENUE BY COUNTRY
-- Business Question:
-- Which markets generate the highest customer value?
--
-- Why it matters:
-- Helps prioritize high-value markets.

SELECT
    Country,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS TotalRevenue
FROM customer_churn
GROUP BY Country
ORDER BY TotalRevenue DESC;


-- REVENUE BY COUNTRY
-- Business Question:
-- Which markets generate the highest customer value?
--
-- Why it matters:
-- Helps prioritize high-value markets.

SELECT
    Country,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS TotalRevenue
FROM customer_churn
GROUP BY Country
ORDER BY TotalRevenue DESC;


-- REVENUE BY ACCOUNT TYPE
-- Business Question:
-- Which products contribute the most revenue?
--
-- Why it matters:
-- Supports product investment decisions.

SELECT
    AccountType,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS TotalRevenue
FROM customer_churn
GROUP BY AccountType
ORDER BY TotalRevenue DESC;


-- TOP REVENUE CUSTOMERS
-- Business Question:
-- Who are the most valuable customers?
--
-- Why it matters:
-- High-value customers require strong retention efforts.

SELECT
    CustomerID,
    Country,
    AccountType,
    EstimatedAnnualRevenue
FROM customer_churn
ORDER BY EstimatedAnnualRevenue DESC
LIMIT 10;

-- CUSTOMER BEHAVIOR COMPARISON
-- Business Question:
-- How do churned customers differ from active customers?
--
-- Why it matters:
-- Helps identify churn indicators.

SELECT
    Churn,
    ROUND(AVG(AverageBalance),2) AS AvgBalance,
    ROUND(AVG(MonthlyTransactions),2) AS AvgTransactions,
    ROUND(AVG(ProductsOwned),2) AS AvgProducts,
    ROUND(AVG(MobileAppLogins),2) AS AvgAppLogins,
    ROUND(AVG(ComplaintsLast12Months),2) AS AvgComplaints
FROM customer_churn
GROUP BY Churn;


-- COMPLAINTS AND CHURN
-- Business Question:
-- Does customer dissatisfaction increase churn risk?
--
-- Why it matters:
-- Complaints are often an early warning signal.

SELECT
    Churn,
    ROUND(AVG(ComplaintsLast12Months),2) AS AvgComplaints
FROM customer_churn
GROUP BY Churn;

-- DIGITAL ENGAGEMENT VS CHURN
-- Business Question:
-- Are digitally engaged customers less likely to churn?
--
-- Why it matters:
-- Identifies opportunities to increase customer stickiness.

SELECT
    Churn,
    ROUND(AVG(MobileAppLogins),2) AS AvgLogins
FROM customer_churn
GROUP BY Churn;

-- REVENUE AT RISK
-- Business Question:
-- How much revenue is associated with churned customers?
--
-- Why it matters:
-- Quantifies the financial impact of customer loss.

SELECT
    ROUND(SUM(EstimatedAnnualRevenue),2) AS RevenueAtRisk
FROM customer_churn
WHERE Churn='Yes';

-- REVENUE AT RISK BY COUNTRY
-- Business Question:
-- Which countries expose the bank to the greatest revenue loss?
--
-- Why it matters:
-- Prioritizes retention investments geographically.

SELECT
    Country,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS RevenueAtRisk
FROM customer_churn
WHERE Churn='Yes'
GROUP BY Country
ORDER BY RevenueAtRisk DESC;

-- CUSTOMER RISK SCORING
-- Business Question:
-- Which customers exhibit the highest churn risk?
--
-- Why it matters:
-- Enables proactive retention before customers leave.

SELECT
    CustomerID,
    Country,
    AccountType,
    (
        CASE WHEN TenureMonths < 12 THEN 20 ELSE 0 END +
        CASE WHEN ProductsOwned <= 2 THEN 20 ELSE 0 END +
        CASE WHEN MonthlyTransactions < 15 THEN 20 ELSE 0 END +
        CASE WHEN AverageBalance < 5000 THEN 20 ELSE 0 END +
        CASE WHEN ComplaintsLast12Months >= 5 THEN 20 ELSE 0 END
    ) AS RiskScore
FROM customer_churn
ORDER BY RiskScore DESC;


-- TOP HIGH-RISK CUSTOMERS
-- Business Question:
-- Which customers need immediate intervention?
--
-- Why it matters:
-- Prioritizes retention efforts.

SELECT
    CustomerID,
    Country,
    AccountType,
    EstimatedAnnualRevenue,
    (
        CASE WHEN TenureMonths < 12 THEN 20 ELSE 0 END +
        CASE WHEN ProductsOwned <= 2 THEN 20 ELSE 0 END +
        CASE WHEN MonthlyTransactions < 15 THEN 20 ELSE 0 END +
        CASE WHEN AverageBalance < 5000 THEN 20 ELSE 0 END +
        CASE WHEN ComplaintsLast12Months >= 5 THEN 20 ELSE 0 END
    ) AS RiskScore
FROM customer_churn
ORDER BY RiskScore DESC,
         EstimatedAnnualRevenue DESC
LIMIT 20;


-- HIGH-VALUE CUSTOMERS
-- Business Question:
-- Who are the bank's most valuable customers?
--
-- Why it matters:
-- These customers should receive premium retention support.

SELECT
    CustomerID,
    Country,
    AccountType,
    EstimatedAnnualRevenue
FROM customer_churn
ORDER BY EstimatedAnnualRevenue DESC
LIMIT 25;

-- HIGH-VALUE CUSTOMERS AT RISK
-- Business Question:
-- Are valuable customers showing churn indicators?
--
-- Why it matters:
-- Losing high-value customers has disproportionate financial impact.

SELECT
    CustomerID,
    Country,
    AccountType,
    EstimatedAnnualRevenue,
    ComplaintsLast12Months,
    MobileAppLogins,
    MonthlyTransactions
FROM customer_churn
WHERE EstimatedAnnualRevenue >
(
    SELECT AVG(EstimatedAnnualRevenue)
    FROM customer_churn
)
AND Churn = 'Yes'
ORDER BY EstimatedAnnualRevenue DESC;


-- CHURN BY TENURE
-- Business Question:
-- At what stage of the customer lifecycle is churn highest?
--
-- Why it matters:
-- Identifies when retention programs should be deployed.

SELECT
    CASE
        WHEN TenureMonths <= 12 THEN '0-12 Months'
        WHEN TenureMonths <= 24 THEN '13-24 Months'
        WHEN TenureMonths <= 60 THEN '25-60 Months'
        ELSE '60+ Months'
    END AS TenureGroup,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY TenureGroup
ORDER BY ChurnRate DESC;


-- PRODUCTS OWNED VS CHURN
-- Business Question:
-- Does owning more products reduce churn?
--
-- Why it matters:
-- Cross-selling may increase retention.

SELECT
    ProductsOwned,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY ProductsOwned
ORDER BY ProductsOwned;

-- PRODUCT PENETRATION ANALYSIS
-- Business Question:
-- Do churned customers own fewer products?
--
-- Why it matters:
-- Measures the effectiveness of product diversification.

SELECT
    Churn,
    ROUND(AVG(ProductsOwned),2) AS AvgProductsOwned
FROM customer_churn
GROUP BY Churn;

SELECT
    ProductsOwned,
    ROUND(AVG(ProductsOwned),2) AS AvgProducts
FROM customer_churn
GROUP BY ProductsOwned;

-- MOBILE APP ENGAGEMENT
-- Business Question:
-- Does digital engagement influence retention?
--
-- Why it matters:
-- Engaged customers tend to be more loyal.

SELECT
    Churn,
    ROUND(AVG(MobileAppLogins),2) AS AvgLogins
FROM customer_churn
GROUP BY Churn;

-- ONLINE BANKING USAGE
-- Business Question:
-- Are digitally active customers less likely to churn?
--
-- Why it matters:
-- Supports digital transformation initiatives.

SELECT
    OnlineBankingUsage,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate
FROM customer_churn
GROUP BY OnlineBankingUsage;


-- EXECUTIVE KPI SUMMARY
-- Business Question:
-- What are the key metrics leadership should monitor?
--
-- Why it matters:
-- Provides a concise executive overview.

SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS ChurnRate,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS TotalRevenue,
    ROUND(AVG(AverageBalance),2) AS AvgBalance,
    ROUND(AVG(MobileAppLogins),2) AS AvgAppLogins
FROM customer_churn;

-- RETENTION OPPORTUNITY SEGMENTS
-- Business Question:
-- Which customer groups present the largest retention opportunity?
--
-- Why it matters:
-- Guides resource allocation.

SELECT
    Country,
    COUNT(*) AS ChurnedCustomers,
    ROUND(SUM(EstimatedAnnualRevenue),2) AS RevenueAtRisk
FROM customer_churn
WHERE Churn='Yes'
GROUP BY Country
ORDER BY RevenueAtRisk DESC;

