-- Gold: review sentiment per franchise.
CREATE OR REFRESH MATERIALIZED VIEW ${medallion_catalog}.${gold_schema}.sentiment_by_franchise
COMMENT "Review sentiment per franchise"
AS SELECT
  f.franchise_id,
  f.franchise_name,
  f.city,
  f.country,
  COUNT(*)                                                         AS reviews,
  COUNT_IF(r.sentiment = 'positive')                               AS positive_reviews,
  COUNT_IF(r.sentiment = 'neutral')                                AS neutral_reviews,
  COUNT_IF(r.sentiment = 'negative')                               AS negative_reviews,
  COUNT_IF(r.sentiment = 'mixed')                                  AS mixed_reviews,
  try_divide(COUNT_IF(r.sentiment = 'positive'), COUNT(*))         AS positive_share,
  MAX(r.review_date)                                               AS last_review_date
FROM ${medallion_catalog}.${silver_schema}.reviews_sentiment r
JOIN ${medallion_catalog}.${silver_schema}.franchises f ON f.franchise_id = r.franchise_id
GROUP BY f.franchise_id, f.franchise_name, f.city, f.country;
