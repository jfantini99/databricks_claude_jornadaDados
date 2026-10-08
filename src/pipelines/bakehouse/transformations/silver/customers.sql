-- Silver: typed, cleaned customers. Country is standardized (source uses 'USA' here
-- but 'US' in franchises) so both dimensions join/aggregate on the same value.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${silver_schema}.customers (
  CONSTRAINT customer_id_not_null EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT email_looks_valid    EXPECT (email_address LIKE '%@%'),
  CONSTRAINT country_present      EXPECT (country IS NOT NULL)
)
COMMENT "Cleaned and conformed customers"
AS SELECT
  CAST(customerID AS BIGINT)                             AS customer_id,
  trim(first_name)                                       AS first_name,
  trim(last_name)                                        AS last_name,
  concat_ws(' ', trim(first_name), trim(last_name))      AS full_name,
  lower(trim(email_address))                             AS email_address,
  phone_number,
  address,
  city,
  state,
  CASE upper(trim(country))
    WHEN 'US'  THEN 'United States'
    WHEN 'USA' THEN 'United States'
    ELSE trim(country)
  END                                                    AS country,
  continent,
  CAST(postal_zip_code AS STRING)                        AS postal_code,
  lower(gender)                                          AS gender,
  _ingested_at
FROM ${medallion_catalog}.${bronze_schema}.customers;
