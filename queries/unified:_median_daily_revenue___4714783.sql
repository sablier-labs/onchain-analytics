-- part of a query repo
-- query name: Unified: Median Daily Revenue
-- query link: https://dune.com/queries/4714783


SELECT approx_percentile(revenue, 0.5) AS median
FROM
    (
        SELECT
            date_trunc('day', block_time) AS "day",
            sum(protocol_revenues_usd) AS revenue
        FROM
            query_4687516
        WHERE
            block_time < date_trunc('day', current_date)
        GROUP BY
            date_trunc('day', block_time)
    )
