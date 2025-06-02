-- part of a query repo
-- query name: Lockup: Withdrawal Revenues
-- query link: https://dune.com/queries/4907842


SELECT
    t.chain,
    t.currency,
    DATE_TRUNC('day', t.block_time) AS revenue_date,
    t.withdrawal_fee AS fee,
    p.price AS usd_asset_price,
    t.withdrawal_fee * p.price AS usd_revenue
FROM
    query_4687435 AS t
LEFT JOIN (
    SELECT DISTINCT
        (DATE_TRUNC('day', timestamp), symbol, contract_address),
        DATE_TRUNC('day', timestamp) AS revenue_day,
        symbol,
        contract_address,
        price
    FROM prices.day
    WHERE contract_address = 0x0000000000000000000000000000000000000000
) AS p
    ON
        DATE_TRUNC('day', t.block_time) = p.revenue_day
        AND t.currency = p.symbol
        AND p.contract_address = 0x0000000000000000000000000000000000000000
