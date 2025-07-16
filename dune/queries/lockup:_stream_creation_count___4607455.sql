-- part of a query repo
-- query name: Lockup: Stream Creation Count (1 Week)
-- query link: https://dune.com/queries/4607455


SELECT COUNT(*)
FROM
    query_4672879 -- Lockup: Data for Creations
WHERE
    evt_block_time >= DATE_TRUNC('day', CURRENT_DATE) - INTERVAL '7' DAY
