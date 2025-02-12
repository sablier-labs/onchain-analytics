-- part of a query repo
-- query name: Lockup: Stream Creation Count (1 Month)
-- query link: https://dune.com/queries/4607442


SELECT COUNT(*)
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time >= DATE_TRUNC('day', CURRENT_DATE) - INTERVAL '1' MONTH
