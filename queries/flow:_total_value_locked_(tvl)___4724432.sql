-- part of a query repo
-- query name: Flow: Total Value Locked (TVL) Distribution by Token
-- query link: https://dune.com/queries/4724432


SELECT
    token,
    symbol,
    price,
    SUM(remaining_balance_value) AS total_balance
FROM
    query_4724379 -- Flow: Priced Adjusted Remaining Balances
GROUP BY
    token,
    symbol,
    price
ORDER BY
    total_balance DESC
LIMIT
    20;
