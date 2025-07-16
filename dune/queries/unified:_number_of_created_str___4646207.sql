-- part of a query repo
-- query name: Unified: Number of Created Streams (Past 24 Hours)
-- query link: https://dune.com/queries/4646207


SELECT
    (
        (
            SELECT COUNT(*)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                evt_block_time > NOW() - INTERVAL '24' HOUR
        ) + (
            SELECT COUNT(*)
            FROM
                query_4596391 -- Flow: Data for Creations
            WHERE
                evt_block_time > NOW() - INTERVAL '24' HOUR
        )
    ) AS created_streams_count_past_24_hours;
