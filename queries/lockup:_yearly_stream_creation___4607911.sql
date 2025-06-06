-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Yearly Stream Creation Count Change
-- query link: https://dune.com/queries/4607911

SELECT
    CASE
        WHEN previous_year_streams = 0 THEN NULL
        ELSE ((current_year_streams - previous_year_streams) * 100.0 / previous_year_streams)
    END AS percentage_change
FROM (
    SELECT
        SUM(CASE WHEN evt_block_time >= CURRENT_DATE - INTERVAL '365' DAY THEN 1 ELSE 0 END) AS current_year_streams,
        SUM(
            CASE
                WHEN
                    evt_block_time >= CURRENT_DATE - INTERVAL '730' DAY
                    AND evt_block_time < CURRENT_DATE - INTERVAL '365' DAY
                    THEN 1
                ELSE 0
            END
        ) AS previous_year_streams
    FROM
        query_4672879 -- Lockup: Data for Creations
    WHERE
        evt_block_time >= CURRENT_DATE - INTERVAL '730' DAY
) AS streams_data;
