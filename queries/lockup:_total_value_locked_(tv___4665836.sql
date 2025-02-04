-- part of a query repo
-- query name: Lockup: Total Value Locked (TVL) Distribution by Chain
-- query link: https://dune.com/queries/4665836


SELECT
    chain,
    SUM(remaining_balance_value) AS total_balance
FROM
    query_4611349 -- Lockup: Priced Adjusted Remaining Balances
GROUP BY
    chain
ORDER BY
    total_balance DESC
