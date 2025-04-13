-- WARNING: this query may be part of multiple repos
-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606974

SELECT SUM(stablecoin_deposit)
FROM
    query_4606918 -- Flow: Data for Deposits
