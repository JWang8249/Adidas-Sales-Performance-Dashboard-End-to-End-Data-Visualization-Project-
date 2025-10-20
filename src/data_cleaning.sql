CREATE TABLE adidas_sales_clean AS
SELECT
    Retailer,
    "Retailer ID"  AS retailer_id,

    printf('%04d-%02d-%02d',
        CAST(
            substr("Invoice Date",
                   instr("Invoice Date", '/') +
                   instr(substr("Invoice Date", instr("Invoice Date", '/') + 1), '/') + 1
            ) AS INTEGER),
        CAST(
            substr("Invoice Date", 1, instr("Invoice Date", '/') - 1) AS INTEGER),
        CAST(
            substr(
                "Invoice Date",
                instr("Invoice Date", '/') + 1,
                instr(substr("Invoice Date", instr("Invoice Date", '/') + 1), '/') - 1
            ) AS INTEGER)
    )    AS invoice_date,

    Region,
    State,
    City,
    Product,

    CAST(REPLACE(REPLACE("Price per Unit",   '$',''), ',', '') AS REAL)    AS price_per_unit,
    CAST(REPLACE(REPLACE("Units Sold",       ',', ''), '"','') AS INTEGER) AS units_sold,
    CAST(REPLACE(REPLACE("Total Sales",      '$',''), ',', '') AS REAL)    AS total_sales,
    CAST(REPLACE(REPLACE("Operating Profit", '$',''), ',', '') AS REAL)    AS operating_profit,
    CAST(REPLACE(REPLACE("Operating Margin", '%',''), ',', '') AS REAL)/100.0 AS operating_margin,
    "Sales Method" AS sales_method
FROM adidas_sales_cleaned
WHERE Retailer IS NOT NULL;

CREATE TABLE dim_city AS
WITH base AS (
    SELECT
        TRIM(City)  AS city_raw,
        TRIM(State) AS state_raw,
        TRIM(Region) AS region_raw
    FROM adidas_sales_clean
),
dedup AS (
    SELECT
        MIN(city_raw)  AS city,
        MIN(state_raw) AS state,
        MIN(region_raw) AS region
    FROM base
    GROUP BY LOWER(city_raw), LOWER(state_raw), LOWER(region_raw)
)
SELECT
    ROW_NUMBER() OVER (ORDER BY city, state, region) AS city_id,
    city   AS City,
    state  AS State,
    region AS Region
FROM dedup;

CREATE TABLE dim_retailer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY TRIM(Retailer)) AS retailer_id,
    TRIM(Retailer) AS retailer_name
FROM adidas_sales_clean
WHERE TRIM(Retailer) <> 'Retailer'
GROUP BY TRIM(Retailer);

CREATE TABLE dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY TRIM(Product)) AS product_id,
    TRIM(Product) AS product_name
FROM (
    SELECT DISTINCT TRIM(Product) AS Product
    FROM adidas_sales_clean
    WHERE Product IS NOT NULL
      AND Product <> 'Product'
);

CREATE TABLE fact_sales AS
SELECT
    a.invoice_date,
    r.retailer_id,
    p.product_id,
    c.city_id,
    a.price_per_unit,
    a.units_sold,
    a.total_sales,
    a.operating_profit,
    a.operating_margin,
    a.sales_method
FROM adidas_sales_clean a
JOIN dim_city c
  ON TRIM(a.City)=TRIM(c.City)
 AND TRIM(a.State)=TRIM(c.State)
 AND TRIM(a.Region)=TRIM(c.Region)
JOIN dim_retailer r
  ON TRIM(a.Retailer)=TRIM(r.retailer_name)
JOIN dim_product p
  ON TRIM(a.Product)=TRIM(p.product_name);