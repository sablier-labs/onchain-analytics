-- part of a query repo
-- query name: Airdrops: Claim Count
-- query link: https://dune.com/queries/4719750


SELECT
    COUNT(*) AS number_of_claims
FROM
    query_4719719 -- Airdrops: Claim Data
WHERE
    contract_address IN ({{Sender/Campaign Addresses}})
    AND block_time > CAST('{{Start Date}}' AS TIMESTAMP)
    AND block_time < CAST('{{End Date}}' AS TIMESTAMP)