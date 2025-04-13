-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606813

SELECT (
    (
        SELECT SUM(stablecoin_deposit)
        FROM query_4672879 -- Lockup: Global Stream Creation Data
    ) + (
        SELECT SUM(stablecoin_deposit)
        FROM query_4596310 -- Legacy: Stream Creation Data
    ) + (
        SELECT SUM(stablecoin_deposit)
        FROM query_4606918 -- Flow: Deposit Data
    )
) AS cumulative_stablecoin_volume
