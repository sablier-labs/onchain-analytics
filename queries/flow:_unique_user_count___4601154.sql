-- part of a query repo
-- query name: Flow: Unique User Count
-- query link: https://dune.com/queries/4601154


SELECT
    COUNT(DISTINCT user)
FROM
    (
        SELECT sender AS user
        FROM query_4596391 -- Unified: Flow Stream Creation Data
        UNION ALL
        SELECT recipient AS user
        FROM query_4596391
    )