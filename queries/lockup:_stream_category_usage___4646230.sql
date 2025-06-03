-- part of a query repo
-- query name: Lockup: Stream Category Usage Distribution
-- query link: https://dune.com/queries/4646230


SELECT
    CASE
        WHEN category = 'lockupLinear' THEN 'Lockup Linear'
        WHEN category = 'lockupDynamic' THEN 'Lockup Dynamic'
        WHEN category = 'lockupTranched' THEN 'Lockup Tranched'
        ELSE 'error'
    END AS category,
    COUNT(*) AS number_of_created_streams
FROM
    query_4672879 -- Lockup: Data for Creations
GROUP BY
    category
