-- part of a query repo
-- query name: Lockup: Total Value Locked (TVL)
-- query link: https://dune.com/queries/4611402


SELECT SUM(remaining_balance_value) AS tvl FROM query_4611349 -- Lockup: Priced Adjusted Remaining Balances
