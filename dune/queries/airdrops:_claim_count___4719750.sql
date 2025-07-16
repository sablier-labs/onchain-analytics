-- part of a query repo
-- query name: Airdrops: Claim Count
-- query link: https://dune.com/queries/4719750


SELECT
    COUNT(*) AS number_of_claims
FROM
    query_4719719 -- Airdrops: Data for Claims
WHERE
    contract_address IN ({{ addresses }}) -- Comma-separated list of sender or campaign addresses
    AND block_time > CAST('{{ start_date }}' AS TIMESTAMP)
    AND block_time < CAST('{{ end_date }}' AS TIMESTAMP)
