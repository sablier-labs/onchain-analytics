-- part of a query repo
-- query name: Flow: Monthly Stablecoin Volume
-- query link: https://dune.com/queries/4614039


SELECT
    date_trunc('month', evt_block_time) AS month,
    SUM(stablecoinDeposit) AS total_deposits
FROM
    query_4606918 -- Flow: Deposit Data
WHERE
    -- evt_block_time < date_trunc('month', current_date) AND
    evt_block_time >= date_trunc('month', current_date) - interval '12' month
GROUP BY
    date_trunc('month', evt_block_time)