-- part of a query repo
-- query name: Unified: Revenues USD Daily
-- query link: https://dune.com/queries/4687748


SELECT
    date_trunc('day', block_time) AS "day",
    sum(protocol_revenues_usd) AS revenue
FROM
    query_4687516
WHERE
    block_time < date_trunc('day', current_date)
GROUP BY
    date_trunc('day', block_time)
