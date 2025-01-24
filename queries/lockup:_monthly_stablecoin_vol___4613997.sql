-- part of a query repo
-- query name: Lockup: Monthly Stablecoin Volume
-- query link: https://dune.com/queries/4613997


SELECT
    date_trunc('month', evt_block_time) AS month,
    SUM(stablecoinDeposit) AS total_deposits
FROM
    query_4580489 -- Lockup: Stream Creation Data
WHERE
    evt_block_time < date_trunc('month', current_date)
    AND evt_block_time >= date_trunc('month', current_date) - interval '12' month
GROUP BY
    date_trunc('month', evt_block_time)