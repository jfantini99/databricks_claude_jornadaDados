-- Gold: sales by franchise country (where the sale happened).
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.sales_by_country
COMMENT "Sales per franchise country"
AS SELECT
  franchise_country                            AS country,
  SUM(total_price)                             AS revenue,
  COUNT(DISTINCT transaction_id)               AS orders,
  SUM(quantity)                                AS units_sold,
  COUNT(DISTINCT franchise_id)                 AS active_franchises,
  COUNT(DISTINCT customer_id)                  AS unique_customers,
  try_divide(SUM(total_price), COUNT(DISTINCT transaction_id)) AS avg_ticket
FROM ${medallion_catalog}.${silver_schema}.transactions
GROUP BY franchise_country;
