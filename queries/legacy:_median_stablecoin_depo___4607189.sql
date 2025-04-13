-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Legacy: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607189

SELECT approx_percentile(stablecoin_deposit, 0.5) AS median
FROM
    query_4596310 -- Legacy: Stream Creation Data
WHERE
    duration > 86400 -- a day
    AND stablecoin_deposit > 50
