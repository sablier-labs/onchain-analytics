-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Legacy: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607189

SELECT approx_percentile(STABLECOIN_DEPOSIT, 0.5) AS MEDIAN
FROM
    QUERY_4596310 -- Legacy: Stream Creation Data
WHERE
    DURATION > 86400 -- a day
    AND STABLECOIN_DEPOSIT > 50
