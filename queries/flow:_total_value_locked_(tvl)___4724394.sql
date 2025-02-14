-- part of a query repo
-- query name: Flow: Total Value Locked (TVL)
-- query link: https://dune.com/queries/4724394


SELECT SUM(remaining_balance_value) AS tvl FROM query_4724379 -- Flow: Priced Adjusted Remaining Balances
