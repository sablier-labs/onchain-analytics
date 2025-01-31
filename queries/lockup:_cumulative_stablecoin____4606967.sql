-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606967

SELECT SUM(STABLECOIN_DEPOSIT)
FROM
    QUERY_4580489 -- Lockup: Stream Creation Data
