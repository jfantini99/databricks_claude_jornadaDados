-- Silver: typed transactions enriched with franchise and customer attributes and
-- derived date columns. The full card number is NOT carried forward, only the last 4 digits.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${silver_schema}.transactions (
  CONSTRAINT transaction_id_not_null EXPECT (transaction_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT positive_quantity       EXPECT (quantity > 0) ON VIOLATION DROP ROW,
  CONSTRAINT non_negative_total      EXPECT (total_price >= 0) ON VIOLATION DROP ROW,
  CONSTRAINT total_matches_lines     EXPECT (total_price = quantity * unit_price),
  CONSTRAINT franchise_resolved      EXPECT (franchise_name IS NOT NULL),
  CONSTRAINT customer_resolved       EXPECT (customer_name IS NOT NULL)
)
COMMENT "Transactions enriched with franchise and customer, with derived date columns"
AS SELECT
  t.transactionID                                        AS transaction_id,
  t.customerID                                           AS customer_id,
  t.franchiseID                                          AS franchise_id,
  t.dateTime                                             AS transaction_ts,
  CAST(t.dateTime AS DATE)                               AS transaction_date,
  date_trunc('MONTH', CAST(t.dateTime AS DATE))          AS transaction_month,
  year(t.dateTime)                                       AS transaction_year,
  month(t.dateTime)                                      AS month_of_year,
  day(t.dateTime)                                        AS day_of_month,
  t.product,
  t.quantity,
  t.unitPrice                                            AS unit_price,
  t.totalPrice                                           AS total_price,
  lower(t.paymentMethod)                                 AS payment_method,
  right(CAST(t.cardNumber AS STRING), 4)                 AS card_last4,
  f.franchise_name,
  f.city                                                 AS franchise_city,
  f.country                                              AS franchise_country,
  c.full_name                                            AS customer_name,
  c.country                                              AS customer_country,
  t._ingested_at
FROM ${medallion_catalog}.${bronze_schema}.transactions t
LEFT JOIN ${medallion_catalog}.${silver_schema}.franchises f ON f.franchise_id = t.franchiseID
LEFT JOIN ${medallion_catalog}.${silver_schema}.customers  c ON c.customer_id  = t.customerID;
