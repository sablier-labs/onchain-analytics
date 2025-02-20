-- part of a query repo
-- query name: Lockup: Weekly Created Streams
-- query link: https://dune.com/queries/4753606


SELECT
    COUNT(*) AS stream_count,
    DATE_TRUNC('week', evt_block_time) AS week_start,
    AVG(COUNT(*))
        OVER (
            ORDER BY DATE_TRUNC('week', evt_block_time) ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        )
        AS moving_avg
FROM
    query_4672879
WHERE
    evt_block_time > FROM_UNIXTIME(1727755200)
    AND DATE_TRUNC('week', evt_block_time) < DATE_TRUNC('week', NOW())
GROUP BY DATE_TRUNC('week', evt_block_time)
ORDER BY week_start;
