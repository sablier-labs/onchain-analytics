-- part of a query repo
-- query name: Flow: Number of Created Streams (Past 24 Hours)
-- query link: https://dune.com/queries/4646202


SELECT
    COUNT(*)
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    evt_block_time > now() - interval '24' hour;