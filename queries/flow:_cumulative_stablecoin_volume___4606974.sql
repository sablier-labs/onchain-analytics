-- part of a query repo
-- query name: Flow: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606974


SELECT
    SUM(stablecoinDeposit)
FROM
    query_4606918 -- Flow: Deposit Data