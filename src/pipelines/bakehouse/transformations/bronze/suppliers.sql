-- Bronze: raw copy of samples.bakehouse.sales_suppliers (read-only source) plus ingestion metadata.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${bronze_schema}.suppliers
COMMENT "Raw ingestion of samples.bakehouse.sales_suppliers"
AS SELECT
  *,
  current_timestamp()                  AS _ingested_at,
  'samples.bakehouse.sales_suppliers'               AS _source_table
FROM samples.bakehouse.sales_suppliers;
