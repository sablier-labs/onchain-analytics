-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Weekly Stream Creation Count Change
-- query link: https://dune.com/queries/4607938

SELECT
    CASE
        WHEN previous_week_streams = 0 THEN 0
        ELSE ((current_week_streams - previous_week_streams) * 100.0 / previous_week_streams)
    END AS percentage_change
FROM (
    SELECT
        SUM(CASE WHEN evt_block_time >= CURRENT_DATE - INTERVAL '7' DAY THEN 1 ELSE 0 END) AS current_week_streams,
        SUM(
            CASE
                WHEN
                    evt_block_time >= CURRENT_DATE - INTERVAL '14' DAY
                    AND evt_block_time < CURRENT_DATE - INTERVAL '7' DAY
                    THEN 1
                ELSE 0
            END
        ) AS previous_week_streams
    FROM
        query_4596391 -- Flow: Data for Creations
    WHERE
        evt_block_time >= CURRENT_DATE - INTERVAL '14' DAY
) AS streams_data;
