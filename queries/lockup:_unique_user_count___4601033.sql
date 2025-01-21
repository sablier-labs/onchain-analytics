-- part of a query repo
-- query name: Lockup: Unique User Count
-- query link: https://dune.com/queries/4601033


SELECT
    COUNT(DISTINCT user)
FROM
    (
        SELECT funder AS user
        FROM query_4580489 -- Unified: Lockup Stream Creation Data
        UNION ALL
        SELECT sender AS user
        FROM query_4580489
        UNION ALL
        SELECT recipient AS user
        FROM query_4580489
    )