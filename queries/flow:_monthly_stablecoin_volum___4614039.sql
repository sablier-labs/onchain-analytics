-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Monthly Stablecoin Volume
-- query link: https://dune.com/queries/4614039

SELECT
    DATE_FORMAT(evt_block_time, '%M %Y') AS evt_month,
    SUM(stablecoin_deposit) AS total_deposits
FROM
    query_4606918 -- Flow: Deposit Data
WHERE
    evt_block_time < DATE_TRUNC('month', CURRENT_DATE)
    AND evt_block_time >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
GROUP BY
    DATE_FORMAT(evt_block_time, '%M %Y'),
    DATE_TRUNC('month', evt_block_time)
ORDER BY
    DATE_TRUNC('month', evt_block_time);
