-- part of a query repo
-- query name: Unified: Stream Count Received by Safe Users
-- query link: https://dune.com/queries/4736093


WITH
sablier_users AS (
    SELECT recipient AS sablier_user
    FROM query_4672879 -- Lockup: Data for Creations
    UNION ALL
    SELECT recipient AS sablier_user
    FROM query_4596310 -- Legacy: Data for Creations
    UNION ALL
    SELECT recipient AS sablier_user
    FROM query_4596391 -- Flow: Data for Creations
)

SELECT COUNT(sablier_user) AS matching_users
FROM
    sablier_users
INNER JOIN safe.safes_all ON sablier_users.sablier_user = safe.safes_all.address;
