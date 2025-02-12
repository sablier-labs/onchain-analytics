-- part of a query repo
-- query name: Unified: Daily Protocol Revenues
-- query link: https://dune.com/queries/4687748


SELECT
    date_trunc('day', block_time) AS "day",
    sum(protocol_revenues_usd) AS revenue
FROM
    query_4687516
GROUP BY
    date_trunc('day', block_time)
