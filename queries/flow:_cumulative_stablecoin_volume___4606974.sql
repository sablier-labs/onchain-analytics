-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606974

SELECT SUM(STABLECOIN_DEPOSIT)
FROM
    QUERY_4606918 -- Flow: Deposit Data
