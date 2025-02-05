-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Unique User Count
-- query link: https://dune.com/queries/4601033

SELECT COUNT(DISTINCT lockup_user)
FROM
    (
        SELECT funder AS lockup_user
        FROM query_4672879 -- Lockup: Global Stream Creation Data
        UNION ALL
        SELECT sender AS lockup_user
        FROM query_4672879 -- Lockup: Global Stream Creation Data
        UNION ALL
        SELECT recipient AS lockup_user
        FROM query_4672879 -- Lockup: Global Stream Creation Data
    )
