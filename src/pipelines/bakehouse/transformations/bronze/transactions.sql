-- Bronze: raw copy of samples.bakehouse.sales_transactions (read-only source) plus ingestion metadata.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${bronze_schema}.transactions
COMMENT "Raw ingestion of samples.bakehouse.sales_transactions"
AS SELECT
  *,
  current_timestamp()                  AS _ingested_at,
  'samples.bakehouse.sales_transactions'               AS _source_table
FROM samples.bakehouse.sales_transactions;
