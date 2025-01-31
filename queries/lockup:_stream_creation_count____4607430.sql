-- part of a query repo
-- query name: Lockup: Stream Creation Count (12 Months)
-- query link: https://dune.com/queries/4607430


SELECT
    COUNT(*)
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time >= date_trunc('day', current_date) - interval '12' month