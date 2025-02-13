-- part of a query repo
-- query name: Airdrops: Daily Claim Count
-- query link: https://dune.com/queries/4719780


SELECT
    COUNT(*) AS number_of_claims,
    date_trunc('day', block_time) AS evt_day
FROM
    query_4719719 -- Airdrops: Claim Data
WHERE
    contract_address IN ({{Sender/Campaign Addresses}})
GROUP BY
    date_trunc('day', block_time)