-- Gold: one row per franchise, with location (for maps) and lifetime sales KPIs.
-- Franchises without sales are kept (orders = 0) so "active" can be derived downstream.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.franchise_performance
COMMENT "Franchise performance with location"
AS SELECT
  f.franchise_id,
  f.franchise_name,
  f.city,
  f.country,
  f.latitude,
  f.longitude,
  f.size,
  COALESCE(SUM(t.total_price), 0)              AS revenue,
  COUNT(DISTINCT t.transaction_id)             AS orders,
  COALESCE(SUM(t.quantity), 0)                 AS units_sold,
  COUNT(DISTINCT t.customer_id)                AS unique_customers,
  try_divide(SUM(t.total_price), COUNT(DISTINCT t.transaction_id)) AS avg_ticket,
  MIN(t.transaction_date)                      AS first_sale_date,
  MAX(t.transaction_date)                      AS last_sale_date
FROM ${medallion_catalog}.${silver_schema}.franchises f
LEFT JOIN ${medallion_catalog}.${silver_schema}.transactions t ON t.franchise_id = f.franchise_id
GROUP BY f.franchise_id, f.franchise_name, f.city, f.country, f.latitude, f.longitude, f.size;
