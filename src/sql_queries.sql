-- Number of retailers, product types, and cities
SELECT
  (SELECT COUNT(*) FROM dim_retailer) AS retailer_count,
  (SELECT COUNT(*) FROM dim_product) AS product_count,
  (SELECT COUNT(*) FROM dim_city) AS city_count;

-- Query data time span
SELECT
  MIN(invoice_date) AS start_date,
  MAX(invoice_date) AS end_date,
  (julianday(MAX(invoice_date)) - julianday(MIN(invoice_date))) AS total_days
FROM fact_sales;

-- Overall sales
SELECT
  ROUND(SUM(total_sales), 2) AS total_revenue,
  ROUND(SUM(operating_profit), 2) AS total_profit,
  ROUND(AVG(operating_margin) * 100, 2) AS avg_margin_percent
FROM fact_sales;

-- Sales by region
SELECT
  c.Region,
  ROUND(SUM(f.total_sales), 2) AS total_revenue,
  ROUND(SUM(f.operating_profit), 2) AS total_profit
FROM fact_sales f
JOIN dim_city c ON f.city_id = c.city_id
GROUP BY c.Region
ORDER BY total_revenue DESC;

-- Average profit margin per retailer
SELECT
  r.retailer_name,
  ROUND(AVG(f.operating_margin) * 100, 2) AS avg_margin_percent,
  ROUND(SUM(f.total_sales), 2) AS total_revenue
FROM fact_sales f
JOIN dim_retailer r ON f.retailer_id = r.retailer_id
GROUP BY r.retailer_name
ORDER BY avg_margin_percent DESC;

-- Monthly sales trends
SELECT
  strftime('%Y-%m', invoice_date) AS month,
  ROUND(SUM(total_sales), 2) AS total_revenue,
  ROUND(SUM(operating_profit), 2) AS total_profit
FROM fact_sales
GROUP BY strftime('%Y-%m', invoice_date)
ORDER BY month;

-- Profit structure of each product line
SELECT
  p.product_name,
  ROUND(SUM(f.total_sales), 2) AS total_revenue,
  ROUND(SUM(f.operating_profit), 2) AS total_profit,
  ROUND(SUM(f.operating_profit) / SUM(f.total_sales) * 100, 2) AS profit_margin_percent
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_percent DESC;

-- Average unit price per city
SELECT
  c.City, c.State, c.Region,
  ROUND(AVG(f.price_per_unit), 2) AS avg_price
FROM fact_sales f
JOIN dim_city c ON f.city_id = c.city_id
GROUP BY c.City, c.State, c.Region
ORDER BY avg_price DESC
LIMIT 10;

-- Calculate sales ranking by retailer
SELECT
  r.retailer_name,
  SUM(f.total_sales) AS total_revenue,
  RANK() OVER (ORDER BY SUM(f.total_sales) DESC) AS sales_rank
FROM fact_sales f
JOIN dim_retailer r ON f.retailer_id = r.retailer_id
GROUP BY r.retailer_name;

-- The most profitable products in each region
WITH rp AS (
  SELECT
    c.Region,
    p.product_name,
    SUM(f.operating_profit) AS region_profit
  FROM fact_sales f
  JOIN dim_city c    ON f.city_id    = c.city_id
  JOIN dim_product p ON f.product_id = p.product_id
  GROUP BY c.Region, p.product_name
)
SELECT Region,
       product_name,
       ROUND(region_profit, 2) AS region_profit
FROM (
  SELECT rp.*,
         ROW_NUMBER() OVER (PARTITION BY Region ORDER BY region_profit DESC) AS rn
  FROM rp
)
WHERE rn = 1
ORDER BY region_profit DESC;