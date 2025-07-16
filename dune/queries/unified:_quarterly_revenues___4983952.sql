-- part of a query repo
-- query name: Unified: Quarterly Revenues
-- query link: https://dune.com/queries/4983952


WITH quarters AS (
    SELECT
        DATE_TRUNC('quarter', revenue_date) AS quarter_start,
        SUM(daily_usd_revenue) AS total_usd_revenue
    FROM query_4983919
    WHERE revenue_date < DATE_TRUNC('quarter', CURRENT_DATE)
    GROUP BY quarter_start
),

ordered_quarters AS (
    SELECT *
    FROM quarters
    ORDER BY quarter_start DESC LIMIT 4
)

SELECT *
FROM ordered_quarters
ORDER BY quarter_start;
