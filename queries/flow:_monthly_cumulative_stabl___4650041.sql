-- part of a query repo
-- query name: Flow: Monthly Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4650041


WITH MonthlyDeposits AS (
    SELECT
        DATE_FORMAT(evt_block_time, '%M %Y') AS evt_month,
        DATE_TRUNC('month', evt_block_time) AS month_start,
        SUM(stablecoin_deposit) AS total_deposits
    FROM
        query_4606918 -- Flow: Deposit Data
    WHERE
        evt_block_time >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
    GROUP BY
        DATE_FORMAT(evt_block_time, '%M %Y'),
        DATE_TRUNC('month', evt_block_time)
),
InitialCumulative AS (
    SELECT 
        COALESCE(SUM(stablecoin_deposit), 0) AS starting_cumulative
    FROM 
        query_4606918 -- Flow: Deposit Data
    WHERE 
        evt_block_time < DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
),
FinalCumulative AS (
    SELECT 
        evt_month,
        month_start,
        total_deposits,
        SUM(total_deposits) OVER (ORDER BY month_start ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
        + (SELECT starting_cumulative FROM InitialCumulative) AS cumulative_volume
    FROM 
        MonthlyDeposits
)
SELECT * FROM FinalCumulative
ORDER BY month_start;