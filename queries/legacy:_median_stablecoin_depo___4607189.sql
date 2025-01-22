-- part of a query repo
-- query name: Legacy: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607189


SELECT
    approx_percentile(stablecoinDeposit, 0.5) AS median
FROM
    query_4596310 -- Legacy: Stream Creation Data
WHERE
    duration > 86400
    AND stablecoinDeposit > 50