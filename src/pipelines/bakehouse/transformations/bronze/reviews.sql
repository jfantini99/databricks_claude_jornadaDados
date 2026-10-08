-- Bronze: raw copy of samples.bakehouse.media_customer_reviews (read-only source) plus ingestion metadata.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${bronze_schema}.reviews
COMMENT "Raw ingestion of samples.bakehouse.media_customer_reviews"
AS SELECT
  *,
  current_timestamp()                  AS _ingested_at,
  'samples.bakehouse.media_customer_reviews'               AS _source_table
FROM samples.bakehouse.media_customer_reviews;
