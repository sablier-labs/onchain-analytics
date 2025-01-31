-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Legacy: Unique User Count
-- query link: https://dune.com/queries/4601157

SELECT COUNT(DISTINCT legacy_user)
FROM
    (
        SELECT sender AS legacy_user
        FROM query_4596310 -- Legacy: Stream Creation Data
        UNION ALL
        SELECT recipient AS legacy_user
        FROM query_4596310 -- Legacy: Stream Creation Data
    )
