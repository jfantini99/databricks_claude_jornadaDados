-- Gold: product mix by country and month.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.sales_by_product
COMMENT "Sales per product, franchise country and month"
AS SELECT
  product,
  franchise_country,
  transaction_month,
  SUM(total_price)                  AS revenue,
  SUM(quantity)                     AS units_sold,
  COUNT(DISTINCT transaction_id)    AS orders
FROM ${medallion_catalog}.${silver_schema}.transactions
GROUP BY product, franchise_country, transaction_month;
