-- part of a query repo
-- query name: Lockup: Median Cliff Duration
-- query link: https://dune.com/queries/4646323


SELECT approx_percentile("cliffDuration", 0.5) / 86400
FROM
    query_4672879 -- Lockup: Global Stream Creation Data
WHERE
    "cliffDuration" > 0
