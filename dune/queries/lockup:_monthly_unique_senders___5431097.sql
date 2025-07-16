-- part of a query repo
-- query name: Lockup: Monthly Unique Senders
-- query link: https://dune.com/queries/5431097


SELECT
    date_trunc('month', evt_block_time) AS active_month,
    count(DISTINCT sender) AS unique_monthly_senders
FROM query_4672879
WHERE date_trunc('month', evt_block_time) < date_trunc('month', now())
GROUP BY 1
ORDER BY 1;
