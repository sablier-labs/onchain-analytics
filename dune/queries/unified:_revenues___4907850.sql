-- part of a query repo
-- query name: Unified: Revenues USD
-- query link: https://dune.com/queries/4907850


SELECT
    chain, currency, revenue_date, fee, usd_asset_price, usd_revenue
FROM
    query_4907530

UNION ALL

SELECT
    chain, currency, revenue_date, fee, usd_asset_price, usd_revenue
FROM
    query_4907842
