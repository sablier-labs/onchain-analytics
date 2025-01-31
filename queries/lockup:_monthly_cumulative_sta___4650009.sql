-- WARNING: this query may be part of multiple repos
-- part of a query repo
-- query name: Lockup: Monthly Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4650009


WITH MONTHLYDEPOSITS AS (
    SELECT
        DATE_FORMAT(EVT_BLOCK_TIME, '%M %Y') AS EVT_MONTH,
        DATE_TRUNC('month', EVT_BLOCK_TIME) AS MONTH_START,
        SUM(STABLECOIN_DEPOSIT) AS TOTAL_DEPOSITS
    FROM
        QUERY_4580489 -- Lockup: Stream Creation Data
    WHERE
        EVT_BLOCK_TIME >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
    GROUP BY
        DATE_FORMAT(EVT_BLOCK_TIME, '%M %Y'),
        DATE_TRUNC('month', EVT_BLOCK_TIME)
),

INITIALCUMULATIVE AS (
    SELECT COALESCE(SUM(STABLECOIN_DEPOSIT), 0) AS STARTING_CUMULATIVE
    FROM
        QUERY_4580489 -- Lockup: Stream Creation Data
    WHERE
        EVT_BLOCK_TIME < DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH
),

FINALCUMULATIVE AS (
    SELECT
        EVT_MONTH,
        MONTH_START,
        TOTAL_DEPOSITS,
        SUM(TOTAL_DEPOSITS)
            OVER (
                ORDER BY MONTH_START ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
        + (SELECT STARTING_CUMULATIVE FROM INITIALCUMULATIVE) AS CUMULATIVE_VOLUME
    FROM
        MONTHLYDEPOSITS
)

SELECT * FROM FINALCUMULATIVE
ORDER BY MONTH_START;
