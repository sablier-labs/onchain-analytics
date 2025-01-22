-- part of a query repo
-- query name: Lockup: Monthly Stream Creation Count Change
-- query link: https://dune.com/queries/4607531


SELECT
    CASE
        WHEN previous_month_streams = 0 THEN NULL
        ELSE ((current_month_streams - previous_month_streams) * 100.0 / previous_month_streams)
    END AS percentage_change
FROM (
    SELECT
        SUM(CASE WHEN evt_block_time >= CURRENT_DATE - INTERVAL '30' day THEN 1 ELSE 0 END) AS current_month_streams,
        SUM(CASE WHEN evt_block_time >= CURRENT_DATE - INTERVAL '60' day AND evt_block_time < CURRENT_DATE - INTERVAL '30' day THEN 1 ELSE 0 END) AS previous_month_streams
    FROM
        query_4580489 -- Lockup: Stream Creation Data
    WHERE
        evt_block_time >= CURRENT_DATE - INTERVAL '60' day
) AS streams_data;