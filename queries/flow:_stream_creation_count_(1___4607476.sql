-- part of a query repo
-- query name: Flow: Stream Creation Count (1 Week)
-- query link: https://dune.com/queries/4607476


SELECT
    COUNT(*)
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    evt_block_time >= date_trunc('day', current_date) - interval '7' day