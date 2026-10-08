-- Gold: grain = day x franchise x payment method (payment method kept so BI can show the
-- payment mix; orders/revenue/units are additive across it, avg ticket is derived in queries).
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.daily_sales_by_franchise
COMMENT "Daily sales per franchise and payment method"
AS SELECT
  transaction_date,
  franchise_id,
  franchise_name,
  franchise_city,
  franchise_country,
  payment_method,
  SUM(total_price)                  AS revenue,
  COUNT(DISTINCT transaction_id)    AS orders,
  SUM(quantity)                     AS units_sold
FROM ${medallion_catalog}.${silver_schema}.transactions
GROUP BY transaction_date, franchise_id, franchise_name, franchise_city, franchise_country, payment_method;
