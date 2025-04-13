-- part of a query repo
-- query name: Lockup: Data for Withdrawals per Stream
-- query link: https://dune.com/queries/4611255


WITH
stream_aggregation AS (
    SELECT
        chain,
        contract_address,
        streamid,
        release_version,
        token,
        SUM(amount) AS total_amount,
        COUNT(*) AS row_count
    FROM
        query_4611102 -- Lockup: Withdrawal Data
    GROUP BY
        chain,
        contract_address,
        release_version,
        streamid,
        token
)

SELECT
    chain,
    contract_address,
    release_version,
    streamid,
    token,
    total_amount
FROM
    stream_aggregation
