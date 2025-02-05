-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607097


SELECT approx_percentile(STABLECOIN_DEPOSIT, 0.5) AS MEDIAN
FROM
    QUERY_4580489 -- Lockup: Global Stream Creation Data
WHERE
    DURATION > 86400 -- a day
    AND STABLECOIN_DEPOSIT > 50
