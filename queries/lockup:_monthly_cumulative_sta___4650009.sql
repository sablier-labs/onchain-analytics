-- WARNING: this query may be part of multiple repos
-- part of a query repo
-- query name: Lockup: Monthly Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4650009


WITH monthly_deposits AS (
    SELECT
        DATE_FORMAT(evt_block_time, '%M %Y') AS evt_month,
        DATE_TRUNC('month', evt_block_time) AS month_start,
        SUM(stablecoin_deposit) AS total_deposits
    FROM
        query_4672879 -- Lockup: Data for Creations
    WHERE
        evt_block_time >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
    GROUP BY
        DATE_FORMAT(evt_block_time, '%M %Y'),
        DATE_TRUNC('month', evt_block_time)
),

initial_cumulative AS (
    SELECT COALESCE(SUM(stablecoin_deposit), 0) AS starting_cumulative
    FROM
        query_4672879 -- Lockup: Data for Creations
    WHERE
        evt_block_time < DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
),

final_cumulative AS (
    SELECT
        evt_month,
        month_start,
        total_deposits,
        SUM(total_deposits)
            OVER (
                ORDER BY month_start ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
        + (SELECT starting_cumulative FROM initial_cumulative) AS cumulative_volume
    FROM
        monthly_deposits
)

SELECT * FROM final_cumulative
ORDER BY month_start;
