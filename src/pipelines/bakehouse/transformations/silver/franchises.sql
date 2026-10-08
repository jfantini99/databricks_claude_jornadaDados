-- Silver: typed, cleaned franchises with the same country standardization as customers.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${silver_schema}.franchises (
  CONSTRAINT franchise_id_not_null EXPECT (franchise_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT latitude_in_range     EXPECT (latitude  BETWEEN -90  AND 90),
  CONSTRAINT longitude_in_range    EXPECT (longitude BETWEEN -180 AND 180),
  CONSTRAINT country_present       EXPECT (country IS NOT NULL)
)
COMMENT "Cleaned and conformed franchises"
AS SELECT
  CAST(franchiseID AS BIGINT)                            AS franchise_id,
  trim(name)                                             AS franchise_name,
  city,
  district,
  CAST(zipcode AS STRING)                                AS zipcode,
  CASE upper(trim(country))
    WHEN 'US'  THEN 'United States'
    WHEN 'USA' THEN 'United States'
    ELSE trim(country)
  END                                                    AS country,
  size,
  CAST(latitude  AS DOUBLE)                              AS latitude,
  CAST(longitude AS DOUBLE)                              AS longitude,
  CAST(supplierID AS BIGINT)                             AS supplier_id,
  _ingested_at
FROM ${medallion_catalog}.${bronze_schema}.franchises;
