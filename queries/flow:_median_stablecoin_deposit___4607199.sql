-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607199

SELECT approx_percentile(STABLECOIN_DEPOSIT, 0.5) AS MEDIAN
FROM
    QUERY_4606918 -- Flow: Deposit Data
WHERE
    STABLECOIN_DEPOSIT > 50
