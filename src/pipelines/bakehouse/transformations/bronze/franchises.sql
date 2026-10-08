-- Bronze: raw copy of samples.bakehouse.sales_franchises (read-only source) plus ingestion metadata.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${bronze_schema}.franchises
COMMENT "Raw ingestion of samples.bakehouse.sales_franchises"
AS SELECT
  *,
  current_timestamp()                  AS _ingested_at,
  'samples.bakehouse.sales_franchises'               AS _source_table
FROM samples.bakehouse.sales_franchises;
