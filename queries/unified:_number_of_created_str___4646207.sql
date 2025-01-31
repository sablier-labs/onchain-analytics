-- part of a query repo
-- query name: Unified: Number of Created Streams (Past 24 Hours)
-- query link: https://dune.com/queries/4646207


SELECT
    (
        (
            SELECT COUNT(*)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                evt_block_time > NOW() - INTERVAL '24' HOUR
        ) + (
            SELECT COUNT(*)
            FROM
                query_4596391 -- Flow: Stream Creation Data
            WHERE
                evt_block_time > NOW() - INTERVAL '24' HOUR
        )
    ) AS created_streams_count_past_24_hours;
