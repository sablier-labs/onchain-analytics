-- part of a query repo
-- query name: Lockup: Stream Creation Count (12 Months)
-- query link: https://dune.com/queries/4607430


SELECT COUNT(*)
FROM
    query_4672879 -- Lockup: Data for Creations
WHERE
    evt_block_time >= DATE_TRUNC('day', CURRENT_DATE) - INTERVAL '12' MONTH
