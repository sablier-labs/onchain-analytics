-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Number of Created Streams (Past 24 Hours)
-- query link: https://dune.com/queries/4629897

SELECT COUNT(*)
FROM
    query_4672879 -- Lockup: Data for Creations
WHERE
    evt_block_time > NOW() - INTERVAL '24' HOUR;
