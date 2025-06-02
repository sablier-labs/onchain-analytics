-- part of a query repo
-- query name: Unified: Total Revenues
-- query link: https://dune.com/queries/4983881


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
GROUP BY currency, revenue_date, usd_asset_price, gbp_usd_price, gbp_asset_price
