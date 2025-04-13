-- part of a query repo
-- query name: Lockup: TVL by Token
-- query link: https://dune.com/queries/4662176


SELECT
    token,
    symbol,
    price,
    SUM(remaining_balance_value) AS total_balance
FROM
    query_4611349 -- Lockup: Priced Adjusted Remaining Balances
GROUP BY
    token,
    symbol,
    price
ORDER BY
    total_balance DESC
LIMIT
    20;
