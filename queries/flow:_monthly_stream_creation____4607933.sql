-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Monthly Stream Creation Count Change
-- query link: https://dune.com/queries/4607933

SELECT
    CASE
        WHEN previous_month_streams = 0 THEN NULL
        ELSE ((current_month_streams - previous_month_streams) * 100.0 / previous_month_streams)
    END AS percentage_change
FROM (
    SELECT
        SUM(CASE WHEN evt_block_time >= CURRENT_DATE - INTERVAL '30' DAY THEN 1 ELSE 0 END) AS current_month_streams,
        SUM(
            CASE
                WHEN
                    evt_block_time >= CURRENT_DATE - INTERVAL '60' DAY
                    AND evt_block_time < CURRENT_DATE - INTERVAL '30' DAY
                    THEN 1
                ELSE 0
            END
        ) AS previous_month_streams
    FROM
        query_4596391 -- Flow: Stream Creation Data
    WHERE
        evt_block_time >= CURRENT_DATE - INTERVAL '60' DAY
) AS streams_data;
