CREATE DATABASE mydata;
USE mydata;

SHOW TABLES;


-- REVENUE BY COUNTRY
-- Business Question:
-- Which countries generate the most revenue?
--
-- Why it matters:
-- Helps leadership identify the strongest markets.
-- Can guide expansion and investment decisions.

SELECT
    c.Country,
    ROUND(SUM(r.RevenueAmount),2) AS TotalRevenue
FROM revenue r
JOIN customers c
    ON r.CustomerID = c.CustomerID
GROUP BY c.Country
ORDER BY TotalRevenue DESC;



-- REVENUE BY INDUSTRY
-- Business Question:
-- Which industries generate the most revenue?
--
-- Why it matters:
-- Reveals the most valuable customer segments.
-- Helps target future sales efforts.


SELECT
    c.Industry,
    ROUND(SUM(r.RevenueAmount),2) AS TotalRevenue
FROM revenue r
JOIN customers c
    ON r.CustomerID = c.CustomerID
GROUP BY c.Industry
ORDER BY TotalRevenue DESC;



-- REVENUE BY SUBSCRIPTION PLAN
-- Business Question:
-- Which plans generate the most revenue?
--
-- Why it matters:
-- Shows which products are driving business growth.


SELECT
    s.Plan,
    ROUND(SUM(r.RevenueAmount),2) AS TotalRevenue
FROM revenue r
JOIN subscriptions s
    ON r.CustomerID = s.CustomerID
GROUP BY s.Plan
ORDER BY TotalRevenue DESC;


-- TOP 20 CUSTOMERS
-- Business Question:
-- Which customers contribute the most revenue?
--
-- Why it matters:
-- Identifies strategic accounts that require
-- strong retention efforts.


SELECT
    c.CompanyName,
    ROUND(SUM(r.RevenueAmount),2) AS Revenue
FROM revenue r
JOIN customers c
    ON r.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY Revenue DESC
LIMIT 20;



-- MONTHLY REVENUE TREND
-- Business Question:
-- Is revenue growing over time?
--
-- Why it matters:
-- Measures business growth and identifies
-- seasonal trends.


SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    ROUND(SUM(RevenueAmount),2) AS Revenue
FROM revenue
GROUP BY
    YEAR(Date),
    MONTH(Date)
ORDER BY
    Year,
    Month;
    
-- CHURN RATE BY SUBSCRIPTION PLAN
-- Business Question:
-- Which plans experience the highest churn?
--
-- Why it matters:
-- Helps identify products needing improvement.

SELECT
    Plan,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Status='Churned'
        THEN 1 ELSE 0 END) AS Churned,
    ROUND(
        SUM(CASE WHEN Status='Churned'
            THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS ChurnRate
FROM subscriptions
GROUP BY Plan
ORDER BY ChurnRate DESC;

-- CHURN RATE BY COUNTRY
-- Business Question:
-- Which markets experience the most customer loss?
--
-- Why it matters:
-- Helps target retention strategies geographically.
SELECT
    c.Country,
    COUNT(*) AS Customers,
    SUM(CASE WHEN s.Status='Churned'
        THEN 1 ELSE 0 END) AS Churned,
    ROUND(
        SUM(CASE WHEN s.Status='Churned'
            THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS ChurnRate
FROM customers c
JOIN subscriptions s
ON c.CustomerID = s.CustomerID
GROUP BY c.Country
ORDER BY ChurnRate DESC;

-- CHURN RATE BY INDUSTRY
-- Business Question:
-- Which industries are most likely to leave?
--
-- Why it matters:
-- Helps identify high-risk customer segments.

SELECT
    c.Industry,
    COUNT(*) AS Customers,
    SUM(CASE WHEN s.Status='Churned'
        THEN 1 ELSE 0 END) AS Churned,
    ROUND(
        SUM(CASE WHEN s.Status='Churned'
            THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS ChurnRate
FROM customers c
JOIN subscriptions s
ON c.CustomerID = s.CustomerID
GROUP BY c.Industry
ORDER BY ChurnRate DESC;


-- TICKETS BY SEVERITY
-- Business Question:
-- What types of issues consume most support resources?
--
-- Why it matters:
-- Helps management understand operational workload
-- and prioritize process improvements.

SELECT
    Severity,
    COUNT(*) AS TicketCount,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM supporttickets),
        2
    ) AS PercentageOfTickets
FROM supporttickets
GROUP BY Severity
ORDER BY TicketCount DESC;

-- RESOLUTION TIME BY SEVERITY
-- Business Question:
-- How long does it take to resolve different issue types?
--
-- Why it matters:
-- Reveals operational efficiency and customer experience.

SELECT
    Severity,
    ROUND(AVG(ResolutionTimeHours),2)
        AS AvgResolutionHours
FROM supporttickets
GROUP BY Severity
ORDER BY AvgResolutionHours DESC;

-- RESOLUTION TIME BY SEVERITY
-- Business Question:
-- How long does it take to resolve different issue types?
--
-- Why it matters:
-- Reveals operational efficiency and customer experience.

SELECT
    Severity,
    ROUND(AVG(ResolutionTimeHours),2)
        AS AvgResolutionHours
FROM supporttickets
GROUP BY Severity
ORDER BY AvgResolutionHours DESC;

-- TOP CUSTOMERS BY SUPPORT TICKETS
-- Business Question:
-- Which customers require the most support?
--
-- Why it matters:
-- Frequent support requests may indicate
-- product issues, training gaps, or churn risk.

SELECT
    c.CompanyName,
    COUNT(*) AS TicketCount
FROM supporttickets s
JOIN customers c
    ON s.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY TicketCount DESC
LIMIT 10;

-- SUPPORT ACTIVITY OF ACTIVE VS CHURNED CUSTOMERS
-- Business Question:
-- Do churned customers submit more tickets?
--
-- Why it matters:
-- Can reveal whether support issues contribute
-- to customer loss.

SELECT
    sub.Status,
    COUNT(st.TicketID) AS TotalTickets,
    ROUND(
        COUNT(st.TicketID) /
        COUNT(DISTINCT sub.CustomerID),
        2
    ) AS AvgTicketsPerCustomer
FROM subscriptions sub
LEFT JOIN supporttickets st
    ON sub.CustomerID = st.CustomerID
GROUP BY sub.Status;

-- HIGH-RISK CUSTOMER ANALYSIS
-- Business Question:
-- Which customers show signs of dissatisfaction?
--
-- Why it matters:
-- Helps identify accounts requiring intervention.

SELECT
    c.CompanyName,
    sub.Status,
    COUNT(st.TicketID) AS TicketCount
FROM customers c
JOIN subscriptions sub
    ON c.CustomerID = sub.CustomerID
LEFT JOIN supporttickets st
    ON c.CustomerID = st.CustomerID
GROUP BY
    c.CompanyName,
    sub.Status
HAVING COUNT(st.TicketID) >= 5
ORDER BY TicketCount DESC
limit 10;

-- MARKETING SPEND BY CHANNEL
-- Business Question:
-- Which channels receive the largest marketing budget?
--
-- Why it matters:
-- Helps leadership understand where acquisition
-- investments are concentrated.

SELECT
    Channel,
    ROUND(SUM(Spend),2) AS TotalSpend
FROM marketingspend
GROUP BY Channel
ORDER BY TotalSpend DESC;

-- COST PER LEAD BY CHANNEL
-- Business Question:
-- Which channels acquire leads most efficiently?
--
-- Why it matters:
-- Lower CPL generally indicates more efficient
-- marketing investment.

SELECT
    Channel,
    ROUND(SUM(Spend),2) AS TotalSpend,
    SUM(Leads) AS TotalLeads,
    ROUND(
        SUM(Spend)/SUM(Leads),
        2
    ) AS CostPerLead
FROM marketingspend
GROUP BY Channel
ORDER BY CostPerLead;

-- MARKETING CHANNEL PERFORMANCE RANKING
-- Business Question:
-- Which channels provide the best overall value?
--
-- Why it matters:
-- Combines spend and lead generation to identify
-- high-performing channels.

SELECT
    Channel,
    ROUND(SUM(Spend),2) AS Spend,
    SUM(Leads) AS Leads,
    ROUND(
        SUM(Leads) /
        SUM(Spend) * 1000,
        2
    ) AS LeadsPer1000Spent
FROM marketingspend
GROUP BY Channel
ORDER BY LeadsPer1000Spent DESC;

-- MONTHLY MARKETING PERFORMANCE
-- Business Question:
-- How have marketing investments changed over time?
--
-- Why it matters:
-- Helps identify seasonality and spending trends.

SELECT
    Month,
    ROUND(SUM(Spend),2) AS TotalSpend,
    SUM(Leads) AS TotalLeads
FROM marketingspend
GROUP BY Month
ORDER BY Month;