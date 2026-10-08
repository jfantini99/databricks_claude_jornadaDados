-- Gold: customer ranking by lifetime revenue. No email/phone: BI doesn't need contact PII.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.top_customers
COMMENT "Customers ranked by revenue"
AS SELECT
  customer_id,
  customer_name,
  customer_country,
  SUM(total_price)                             AS revenue,
  COUNT(DISTINCT transaction_id)               AS orders,
  SUM(quantity)                                AS units_sold,
  try_divide(SUM(total_price), COUNT(DISTINCT transaction_id)) AS avg_ticket,
  MIN(transaction_date)                        AS first_purchase_date,
  MAX(transaction_date)                        AS last_purchase_date,
  RANK() OVER (ORDER BY SUM(total_price) DESC) AS revenue_rank
FROM ${medallion_catalog}.${silver_schema}.transactions
GROUP BY customer_id, customer_name, customer_country;
