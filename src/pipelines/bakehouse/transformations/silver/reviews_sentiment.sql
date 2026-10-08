-- Silver: customer reviews scored with ai_analyze_sentiment (positive/negative/neutral/mixed).
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${silver_schema}.reviews_sentiment (
  CONSTRAINT review_text_present EXPECT (review IS NOT NULL AND length(trim(review)) > 0) ON VIOLATION DROP ROW,
  CONSTRAINT franchise_id_present EXPECT (franchise_id IS NOT NULL),
  CONSTRAINT sentiment_resolved   EXPECT (sentiment IS NOT NULL)
)
COMMENT "Customer reviews with AI-derived sentiment"
AS SELECT
  new_id                                                 AS review_id,
  franchiseID                                            AS franchise_id,
  review_date                                            AS review_ts,
  CAST(review_date AS DATE)                              AS review_date,
  date_trunc('MONTH', CAST(review_date AS DATE))         AS review_month,
  review,
  ai_analyze_sentiment(review)                           AS sentiment,
  _ingested_at
FROM ${medallion_catalog}.${bronze_schema}.reviews;
