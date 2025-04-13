-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Monthly Stream Creation Count
-- query link: https://dune.com/queries/4607341


SELECT
    DATE_FORMAT(evt_block_time, '%M %Y') AS evt_month,
    COUNT(*) AS number_of_created_streams
FROM
    query_4596391 -- Flow: Data for Creations
WHERE
    -- evt_block_time < DATE_TRUNC('month', current_date) AND
    evt_block_time >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
GROUP BY
    DATE_FORMAT(evt_block_time, '%M %Y'),
    DATE_TRUNC('month', evt_block_time)
ORDER BY
    DATE_TRUNC('month', evt_block_time);
