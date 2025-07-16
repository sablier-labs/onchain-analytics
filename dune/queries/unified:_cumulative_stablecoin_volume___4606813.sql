-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606813

SELECT (
    (
        SELECT SUM(stablecoin_deposit)
        FROM query_4672879 -- Lockup: Data for Creations
    ) + (
        SELECT SUM(stablecoin_deposit)
        FROM query_4596310 -- Legacy: Data for Creations
    ) + (
        SELECT SUM(stablecoin_deposit)
        FROM query_4606918 -- Flow: Data for Deposits
    )
) AS cumulative_stablecoin_volume
