-- part of a query repo
-- query name: Flow: Monthly Stream Creation Count
-- query link: https://dune.com/queries/4607341


SELECT
    DATE_FORMAT(evt_block_time, '%M %Y') AS month,
    COUNT(*) AS number_of_created_streams
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    -- evt_block_time < date_trunc('month', current_date) AND
    evt_block_time >= date_trunc('month', current_date) - interval '12' month
GROUP BY
    DATE_FORMAT(evt_block_time, '%M %Y'),
    date_trunc('month', evt_block_time)
ORDER BY
    date_trunc('month', evt_block_time);