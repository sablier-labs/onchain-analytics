-- part of a query repo
-- query name: Lockup: Stream Creation Count (1 Month)
-- query link: https://dune.com/queries/4607442


SELECT
    COUNT(*)
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time >= date_trunc('day', current_date) - interval '1' month