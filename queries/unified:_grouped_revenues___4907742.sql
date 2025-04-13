-- part of a query repo
-- query name: Unified: Revenues Grouped
-- query link: https://dune.com/queries/4907742


SELECT
    currency,
    revenue_date,
    usd_asset_price,
    gbp_usd_price,
    gbp_asset_price,
    SUM(fee) AS fee,
    SUM(usd_revenue) AS total_usd_revenue,
    SUM(gbp_revenue) AS total_gbp_revenue
FROM query_4915961
WHERE revenue_date >= DATE_TRUNC('day', CAST('{{Begin Date}}' AS TIMESTAMP)) AND revenue_date <= DATE_TRUNC('day', CAST('{{End Date}}' AS TIMESTAMP))
GROUP BY currency, revenue_date, usd_asset_price, gbp_usd_price, gbp_asset_price
