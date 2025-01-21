-- part of a query repo
-- query name: Unified: Unique User Count
-- query link: https://dune.com/queries/4600977


SELECT
    COUNT(DISTINCT user)
FROM
    (
        SELECT funder AS user
        FROM query_4580489 -- Lockup: Stream Creation Data
        UNION ALL
        SELECT sender AS user
        FROM query_4580489
        UNION ALL
        SELECT recipient AS user
        FROM query_4580489
        UNION ALL
        SELECT sender AS user
        FROM query_4596310 -- Legacy: Stream Creation Data
        UNION ALL
        SELECT recipient AS user
        FROM query_4596310
        UNION ALL
        SELECT sender AS user
        FROM query_4596391 -- Flow: Stream Creation Data
        UNION ALL
        SELECT recipient AS user
        FROM query_4596391
    )FROM query_4596391
    )