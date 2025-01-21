-- part of a query repo
-- query name: Legacy: Unique User Count
-- query link: https://dune.com/queries/4601157


SELECT
    COUNT(DISTINCT user)
FROM
    (
        SELECT sender AS user
        FROM query_4596310 -- Legacy: Stream Creation Data
        UNION ALL
        SELECT recipient AS user
        FROM query_4596310
    )