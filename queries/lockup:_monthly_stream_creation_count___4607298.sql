-- part of a query repo
-- query name: Lockup: Monthly Stream Creation Count
-- query link: https://dune.com/queries/4607298


SELECT
    DATE_FORMAT(evt_block_time, '%M %Y') AS month,
    COUNT(*) AS number_of_created_streams
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time < date_trunc('month', current_date)
    AND evt_block_time >= date_trunc('month', current_date) - interval '12' month
GROUP BY
    DATE_FORMAT(evt_block_time, '%M %Y'),
    date_trunc('month', evt_block_time)
ORDER BY
    date_trunc('month', evt_block_time);