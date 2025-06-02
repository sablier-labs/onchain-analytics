-- part of a query repo
-- query name: Unified: Revenues USD
-- query link: https://dune.com/queries/4687516


WITH price_lookup AS (
    SELECT
        currency,
        price
    FROM (
        SELECT
            CASE blockchain
                WHEN 'avalanche_c' THEN 'AVAX'
                WHEN 'ethereum' THEN 'ETH'
                WHEN 'bnb' THEN 'BNB'
                WHEN 'polygon' THEN 'POL'
                WHEN 'gnosis' THEN 'XDAI'
            END AS currency,
            price,
            ROW_NUMBER() OVER (
                PARTITION BY blockchain
                ORDER BY timestamp DESC
            ) AS rn
        FROM prices.day
        WHERE
            blockchain IN ('avalanche_c', 'ethereum', 'bnb', 'polygon', 'gnosis')
            AND contract_address = 0x0000000000000000000000000000000000000000
    ) AS sub
    WHERE rn = 1
)

SELECT
    t.category,
    t.chain,
    t.currency,
    t.block_time,
    t.protocol_revenues,
    t.protocol_revenues * p.price AS protocol_revenues_usd
FROM (
    SELECT
        'Airdrops' AS category,
        chain,
        currency,
        block_time,
        airdrop_fee AS protocol_revenues
    FROM query_4676715
    UNION ALL
    SELECT
        'Withdrawals' AS category,
        chain,
        currency,
        block_time,
        withdrawal_fee AS protocol_revenues
    FROM query_4687435
) AS t
LEFT JOIN price_lookup AS p ON t.currency = p.currency;
