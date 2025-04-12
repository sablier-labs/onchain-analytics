-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607097


SELECT approx_percentile(STABLECOIN_DEPOSIT, 0.5) AS MEDIAN
FROM
    QUERY_4672879 -- Lockup: Data for Creations
WHERE
    DURATION > 86400 -- a day
    AND STABLECOIN_DEPOSIT > 50
