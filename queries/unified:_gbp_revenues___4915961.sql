-- part of a query repo
-- query name: Unified: GBP Revenues
-- query link: https://dune.com/queries/4915961


SELECT
    q.chain,
    q.currency,
    q.revenue_date,
    q.fee,
    q.usd_asset_price,
    q.usd_revenue,
    p.price AS gbp_usd_price,
    q.usd_asset_price / p.price AS gbp_asset_price,
    q.usd_revenue / p.price AS gbp_revenue
FROM
    query_4907850 AS q
LEFT JOIN
    prices.day AS p
    ON
        DATE(q.revenue_date) = DATE(p.timestamp)
WHERE
    p.blockchain = 'gnosis'
    AND p.contract_address = 0x5cb9073902f2035222b9749f8fb0c9bfe5527108
