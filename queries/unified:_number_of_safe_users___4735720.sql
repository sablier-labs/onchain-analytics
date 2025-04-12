-- part of a query repo
-- query name: Unified: Number of Safe Users
-- query link: https://dune.com/queries/4735720


WITH
sablier_users AS (
    SELECT funder AS sablier_user
    FROM
        query_4672879 -- Lockup: Data for Creations
    UNION ALL
    SELECT sender AS sablier_user
    FROM
        query_4672879 -- Lockup: Data for Creations
    UNION ALL
    SELECT recipient AS sablier_user
    FROM
        query_4672879 -- Lockup: Data for Creations
    UNION ALL
    SELECT sender AS sablier_user
    FROM
        query_4596310 -- Legacy: Stream Creation Data
    UNION ALL
    SELECT recipient AS sablier_user
    FROM
        query_4596310 -- Legacy: Stream Creation Data
    UNION ALL
    SELECT sender AS sablier_user
    FROM
        query_4596391 -- Flow: Stream Creation Data
    UNION ALL
    SELECT recipient AS sablier_user
    FROM
        query_4596391 -- Flow: Stream Creation Data
)

SELECT COUNT(DISTINCT sablier_user) AS matching_users
FROM
    sablier_users
LEFT JOIN safe.safes_all ON sablier_users.sablier_user = safe.safes_all.address;
