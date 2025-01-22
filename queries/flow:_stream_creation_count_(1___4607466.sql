-- part of a query repo
-- query name: Flow: Stream Creation Count (12 Months)
-- query link: https://dune.com/queries/4607466


SELECT
    COUNT(*)
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    evt_block_time >= date_trunc('day', current_date) - interval '12' month