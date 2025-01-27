-- part of a query repo
-- query name: Lockup: Number of Created Streams (Past 24 Hours)
-- query link: https://dune.com/queries/4629897


SELECT
    COUNT(*)
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time > now() - interval '24' hour;