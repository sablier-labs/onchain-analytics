-- part of a query repo
-- query name: Flow: TVL by Chain
-- query link: https://dune.com/queries/4724441


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
    SUM(remaining_balance_value) AS total_balance
FROM
    query_4724379 -- Flow: Priced Adjusted Remaining Balances
GROUP BY
    chain
ORDER BY
    total_balance DESC
