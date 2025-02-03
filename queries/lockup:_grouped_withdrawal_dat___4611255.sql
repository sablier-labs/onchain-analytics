-- part of a query repo
-- query name: Lockup: Grouped Withdrawal Data
-- query link: https://dune.com/queries/4611255


WITH
STREAMAGGREGATION AS (
    SELECT
        CHAIN,
        CONTRACT_ADDRESS,
        CONTRACT,
        STREAMID,
        RELEASE_VERSION,
        TOKEN,
        SUM(AMOUNT) AS TOTAL_AMOUNT,
        COUNT(*) AS ROW_COUNT
    FROM
        QUERY_4611102 -- Lockup: Withdrawal Data
    GROUP BY
        CHAIN,
        CONTRACT_ADDRESS,
        RELEASE_VERSION,
        CONTRACT,
        STREAMID,
        TOKEN
)

SELECT
    CHAIN,
    CONTRACT_ADDRESS,
    CONTRACT,
    RELEASE_VERSION,
    STREAMID,
    TOKEN,
    TOTAL_AMOUNT
FROM
    STREAMAGGREGATION
