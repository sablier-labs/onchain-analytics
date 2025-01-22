-- part of a query repo
-- query name: Flow: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607199


SELECT
    approx_percentile(stablecoinDeposit, 0.5) AS median
FROM
    query_4606918 -- Flow: Deposit Data
WHERE
    stablecoinDeposit > 50