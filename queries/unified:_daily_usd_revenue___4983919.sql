-- part of a query repo
-- query name: Unified: Daily USD Revenue
-- query link: https://dune.com/queries/4983919


SELECT
  revenue_date,
  SUM(total_usd_revenue) AS daily_usd_revenue
FROM
  query_4983881
GROUP BY
  revenue_date
ORDER BY
  revenue_date;