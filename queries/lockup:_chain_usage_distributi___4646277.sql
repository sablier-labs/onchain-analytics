-- part of a query repo
-- query name: Lockup: Chain Usage Distribution
-- query link: https://dune.com/queries/4646277


SELECT
    CASE
        WHEN chain = 'ethereum' THEN 'Ethereum'
        WHEN chain = 'base' THEN 'Base'
        WHEN chain = 'optimism' THEN 'Optimism'
        WHEN chain = 'arbitrum' THEN 'Arbitrum'
        WHEN chain = 'gnosis' THEN 'Gnosis Chain'
        WHEN chain = 'linea' THEN 'Linea'
        WHEN chain = 'blast' THEN 'Blast'
        WHEN chain = 'avalanche_c' THEN 'Avalanche'
        WHEN chain = 'bnb' THEN 'BNB Chain'
        WHEN chain = 'polygon' THEN 'Polygon'
        WHEN chain = 'scroll' THEN 'Scroll'
        WHEN chain = 'zksync' THEN 'zkSync'
        ELSE 'error'
    END AS chain,
    COUNT(*) AS number_of_created_streams
FROM
    query_4672879 -- Lockup: Data for Creations
GROUP BY
    chain
