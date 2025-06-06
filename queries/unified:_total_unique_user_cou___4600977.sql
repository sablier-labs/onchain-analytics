-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Unique User Count
-- query link: https://dune.com/queries/4600977

SELECT COUNT(DISTINCT sablier_user)
FROM
    (
        SELECT funder AS sablier_user
        FROM query_4672879 -- Lockup: Data for Creations
        UNION ALL
        SELECT sender AS sablier_user
        FROM query_4672879 -- Lockup: Data for Creations
        UNION ALL
        SELECT recipient AS sablier_user
        FROM query_4672879 -- Lockup: Data for Creations
        UNION ALL
        SELECT sender AS sablier_user
        FROM query_4596310 -- Legacy: Data for Creations
        UNION ALL
        SELECT recipient AS sablier_user
        FROM query_4596310 -- Legacy: Data for Creations
        UNION ALL
        SELECT sender AS sablier_user
        FROM query_4596391 -- Flow: Data for Creations
        UNION ALL
        SELECT recipient AS sablier_user
        FROM query_4596391 -- Flow: Data for Creations
    )
