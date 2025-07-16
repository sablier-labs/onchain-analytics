-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607097


SELECT approx_percentile(stablecoin_deposit, 0.5) AS median
FROM
    query_4672879 -- Lockup: Data for Creations
WHERE
    duration > 86400 -- a day
    AND stablecoin_deposit > 50
