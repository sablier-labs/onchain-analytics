-- part of a query repo
-- query name: Unified: Grouped Revenues
-- query link: https://dune.com/queries/4907742


SELECT currency, revenue_date, usd_asset_price, SUM(fee) AS fee, SUM(usd_revenue) AS total_usd_revenue FROM query_4907850 GROUP BY currency, revenue_date, usd_asset_price