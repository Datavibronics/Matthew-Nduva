SELECT *
FROM `superstore data`;

-- ABOUT: Extracts the year from your existing 'Order Date' text on the fly, calculating annual metrics and YoY growth trends.
-- INSIGHT: Revenue scaled significantly up to 2017, but tracking net margin percentages reveals whether rapid scaling has compromised underlying profitability.
WITH yearly_metrics AS (
    SELECT 
        CASE 
            WHEN `Order Date` LIKE '%/%' THEN RIGHT(`Order Date`, 4) -- Extracts '2016' from '11/8/2016'
            ELSE LEFT(`Order Date`, 4)                              -- Extracts '2016' from '2016-11-08'
        END AS fiscal_year,
        ROUND(SUM(`Sales`), 2) AS total_sales,
        ROUND(SUM(`Profit`), 2) AS total_profit,
        ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS net_profit_margin_pct
    FROM `superstore data`
    GROUP BY 
        CASE 
            WHEN `Order Date` LIKE '%/%' THEN RIGHT(`Order Date`, 4)
            ELSE LEFT(`Order Date`, 4)
        END
)
SELECT 
    fiscal_year,
    total_sales,
    ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY fiscal_year)) / LAG(total_sales) OVER (ORDER BY fiscal_year)) * 100, 2) AS yoy_sales_growth_pct,
    total_profit,
    ROUND(((total_profit - LAG(total_profit) OVER (ORDER BY fiscal_year)) / LAG(total_profit) OVER (ORDER BY fiscal_year)) * 100, 2) AS yoy_profit_growth_pct,
    net_profit_margin_pct
FROM yearly_metrics
ORDER BY fiscal_year;


-- ABOUT: Dynamically parses date strings to construct accurate recency interval spreads across individual consumer purchase histories.
-- INSIGHT: Separating top-tier customer assets from churning accounts lets corporate marketing run hyper-targeted retention campaigns.
WITH customer_rfm_base AS (
    SELECT 
        `Customer ID`,
        `Customer Name`,
        DATEDIFF(
            (SELECT MAX(CASE WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Order Date`, '%Y-%m-%d') END) FROM `superstore data`), 
            MAX(CASE WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Order Date`, '%Y-%m-%d') END)
        ) AS recency_days,
        COUNT(DISTINCT `Order ID`) AS frequency,
        SUM(`Sales`) AS total_monetary
    FROM `superstore data`
    GROUP BY `Customer ID`, `Customer Name`
),
rfm_scores AS (
    SELECT 
        `Customer ID`,
        `Customer Name`,
        recency_days,
        frequency,
        total_monetary,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score, 
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,   
        NTILE(5) OVER (ORDER BY total_monetary DESC) AS m_score 
    FROM customer_rfm_base
)
SELECT 
    `Customer ID`,
    `Customer Name`,
    recency_days,
    frequency,
    ROUND(total_monetary, 2) AS total_monetary,
    CONCAT(r_score, f_score, m_score) AS rfm_cell,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions / Core VIP'
        WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At-Risk High Spenders'
        WHEN r_score >= 3 AND f_score <= 2 AND m_score >= 4 THEN 'New Big Spenders'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost / Low Value'
        ELSE 'Regular / General Base'
    END AS customer_segment
FROM rfm_scores
ORDER BY total_monetary DESC;



-- ABOUT: Standardizes ship and order date text configurations to isolate operational logjams across distribution nodes.
-- INSIGHT: Pinpointing localized distribution regions experiencing higher fulfillment timelines allows the operation to renegotiate delivery carrier SLA structures.
SELECT 
    `Region`,
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(AVG(DATEDIFF(
        CASE WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Ship Date`, '%Y-%m-%d') END, 
        CASE WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Order Date`, '%Y-%m-%d') END
    )), 2) AS avg_days_to_ship,
    SUM(CASE WHEN DATEDIFF(
        CASE WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Ship Date`, '%Y-%m-%d') END, 
        CASE WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Order Date`, '%Y-%m-%d') END
    ) > 5 THEN 1 ELSE 0 END) AS critical_delayed_orders,
    ROUND((SUM(CASE WHEN DATEDIFF(
        CASE WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Ship Date`, '%Y-%m-%d') END, 
        CASE WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') ELSE STR_TO_DATE(`Order Date`, '%Y-%m-%d') END
    ) > 5 THEN 1 ELSE 0 END) / COUNT(`Order ID`)) * 100, 2) AS logistics_failure_rate_pct
FROM `superstore data`
GROUP BY `Region`, `Ship Mode`
ORDER BY logistics_failure_rate_pct DESC, `Region` ASC;






-- ABOUT: Converts multi-format entries to a clean standardized $YYYY-MM$ expression for sequential window tracking.
-- INSIGHT: Reveals predictable seasonal pullbacks in Q1 followed by massive accelerations in Q4, helping management optimize working capital reserves.
WITH monthly_sales AS (
    SELECT 
        CASE 
            WHEN `Order Date` LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m')
            ELSE LEFT(`Order Date`, 7)
        END AS sales_month,
        SUM(`Sales`) AS monthly_gross_revenue,
        SUM(`Profit`) AS monthly_net_profit
    FROM `superstore data`
    GROUP BY 
        CASE 
            WHEN `Order Date` LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m')
            ELSE LEFT(`Order Date`, 7)
        END
)
SELECT 
    sales_month,
    ROUND(monthly_gross_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_gross_revenue) OVER (ORDER BY sales_month ROWS UNBOUNDED PRECEDING), 2) AS cumulative_running_revenue,
    ROUND(monthly_net_profit, 2) AS monthly_profit,
    ROUND(SUM(monthly_net_profit) OVER (ORDER BY sales_month ROWS UNBOUNDED PRECEDING), 2) AS cumulative_running_profit
FROM monthly_sales
ORDER BY sales_month;



-- ABOUT: Evaluates overall revenue volumes, total profits, and net margin percentage performance across primary product categories.
SELECT 
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_gross_sales,
    ROUND(SUM(`Profit`), 2) AS total_net_profit,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS net_profit_margin_pct,
    SUM(`Quantity`) AS total_units_sold,
    ROUND(AVG(`Discount`) * 100, 2) AS average_promotional_discount_pct
FROM `superstore data`
GROUP BY `Category`
ORDER BY total_net_profit DESC;


-- ABOUT: Uses window partitioning to isolate and rank the number-one revenue-generating sub-category within each distinct geographic region.
WITH regional_subcategory_sales AS (
    SELECT 
        `Region`,
        `Sub-Category`,
        ROUND(SUM(`Sales`), 2) AS total_sales,
        ROUND(SUM(`Profit`), 2) AS total_profit,
        ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS regional_margin_pct,
        ROW_NUMBER() OVER (PARTITION BY `Region` ORDER BY SUM(`Sales`) DESC) AS regional_revenue_rank
    FROM `superstore data`
    GROUP BY `Region`, `Sub-Category`
)
SELECT 
    `Region`,
    `Sub-Category` AS dominant_sub_category,
    total_sales AS leadership_revenue_volume,
    total_profit AS net_profit_generated,
    regional_margin_pct
FROM regional_subcategory_sales
WHERE regional_revenue_rank = 1
ORDER BY total_sales DESC;


-- ABOUT: Automatically profiles sub-categories into operational matrix segments based on company-wide sales and profit averages.
WITH corporate_averages AS (
    SELECT 
        AVG(sub_sales) AS avg_sub_sales,
        AVG(sub_profit) AS avg_sub_profit
    FROM (
        SELECT SUM(`Sales`) AS sub_sales, SUM(`Profit`) AS sub_profit 
        FROM `superstore data` 
        GROUP BY `Sub-Category`
    ) AS sub_metrics
),
subcategory_performance AS (
    SELECT 
        `Category`,
        `Sub-Category`,
        SUM(`Sales`) AS total_sales,
        SUM(`Profit`) AS total_profit
    FROM `superstore data`
    GROUP BY `Category`, `Sub-Category`
)
SELECT 
    p.`Category`,
    p.`Sub-Category`,
    ROUND(p.total_sales, 2) AS total_sales,
    ROUND(p.total_profit, 2) AS total_profit,
    CASE 
        WHEN p.total_sales >= a.avg_sub_sales AND p.total_profit >= a.avg_sub_profit THEN 'High Performance Star'
        WHEN p.total_sales >= a.avg_sub_sales AND p.total_profit < a.avg_sub_profit  THEN 'Volume Driver / Profit Drain'
        WHEN p.total_sales < a.avg_sub_sales  AND p.total_profit >= a.avg_sub_profit THEN 'Niche Profit Generator'
        ELSE 'Underperforming Line / Dog'
    END AS portfolio_strategic_classification
FROM subcategory_performance p
CROSS JOIN corporate_averages a
ORDER BY p.total_profit DESC;



-- ABOUT: Aggregates performance by State and City to locate high-revenue markets suffering from negative bottom-line returns.
SELECT 
    `State`,
    `City`,
    COUNT(DISTINCT `Order ID`) AS order_volume,
    ROUND(SUM(`Sales`), 2) AS total_gross_revenue,
    ROUND(SUM(`Profit`), 2) AS net_profit_loss,
    ROUND(AVG(`Discount`) * 100, 2) AS localized_avg_discount_pct
FROM `superstore data`
GROUP BY `State`, `City`
HAVING SUM(`Profit`) < 0 AND SUM(`Sales`) > 5000 -- Isolates large, high-revenue markets that are underwater
ORDER BY net_profit_loss ASC;


-- ABOUT: Tracks annual sales revenue patterns broken down across core categories to show market momentum.
SELECT 
    CASE 
        WHEN `Order Date` LIKE '%/%' THEN RIGHT(`Order Date`, 4)
        ELSE LEFT(`Order Date`, 4)
    END AS fiscal_year,
    `Category`,
    ROUND(SUM(`Sales`), 2) AS annual_sales,
    ROUND(SUM(`Profit`), 2) AS annual_profit,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS annual_margin_pct
FROM `superstore data`
GROUP BY 
    CASE 
        WHEN `Order Date` LIKE '%/%' THEN RIGHT(`Order Date`, 4)
        ELSE LEFT(`Order Date`, 4)
    END,
    `Category`
ORDER BY fiscal_year ASC, annual_sales DESC;