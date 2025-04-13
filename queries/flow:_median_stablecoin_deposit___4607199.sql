-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4607199

SELECT approx_percentile(stablecoin_deposit, 0.5) AS median
FROM
    query_4606918 -- Flow: Data for Deposits
WHERE
    stablecoin_deposit > 50
