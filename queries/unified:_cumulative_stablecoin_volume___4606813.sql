-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606813

SELECT (
    (
        SELECT SUM(STABLECOIN_DEPOSIT)
        FROM QUERY_4580489 -- Lockup: Stream Creation Data
    ) + (
        SELECT SUM(STABLECOIN_DEPOSIT)
        FROM QUERY_4596310 -- Legacy: Stream Creation Data
    ) + (
        SELECT SUM(STABLECOIN_DEPOSIT)
        FROM QUERY_4606918 -- Flow: Deposit Data
    )
) AS CUMULATIVE_STABLECOIN_VOLUME
