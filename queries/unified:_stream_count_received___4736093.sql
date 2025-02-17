-- part of a query repo
-- query name: Unified: Stream Count Received by Safe Wallets
-- query link: https://dune.com/queries/4736093


WITH
sablier_users AS (
    SELECT recipient AS sablier_user
    FROM query_4672879 -- Lockup: Global Stream Creation Data
    UNION ALL
    SELECT recipient AS sablier_user
    FROM query_4596310 -- Legacy: Stream Creation Data
    UNION ALL
    SELECT recipient AS sablier_user
    FROM query_4596391 -- Flow: Stream Creation Data
)

SELECT COUNT(sablier_user) AS matching_users
FROM
    sablier_users
LEFT JOIN safe.safes_all ON sablier_users.sablier_user = safe.safes_all.address;
