-- part of a query repo
-- query name: Airdrops: Daily Claim Count
-- query link: https://dune.com/queries/4719780


SELECT
    COUNT(*) AS number_of_claims,
    DATE_TRUNC('day', block_time) AS evt_day
FROM
    query_4719719 -- Airdrops: Data for Claims
WHERE
    contract_address IN ({{ addresses }}) -- Comma-separated list of sender or campaign addresses
GROUP BY
    DATE_TRUNC('day', block_time)
