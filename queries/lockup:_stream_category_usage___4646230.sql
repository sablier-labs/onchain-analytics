-- part of a query repo
-- query name: Lockup: Stream Category Usage Distribution
-- query link: https://dune.com/queries/4646230


SELECT
    CASE
        WHEN contract = 'lockupLinear' THEN 'Lockup Linear'
        WHEN contract = 'lockupDynamic' THEN 'Lockup Dynamic'
        WHEN contract = 'lockupTranched' THEN 'Lockup Tranched'
        ELSE 'error'
    END AS contract,
    COUNT(*) AS number_of_created_streams
FROM
    query_4580489 -- Lockup: Stream Creation Data
GROUP BY
    contract
