-- part of a query repo
-- query name: Lockup: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607097


SELECT
    approx_percentile(stablecoinDeposit, 0.5) AS median
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    duration > 86400
    AND stablecoinDeposit > 50