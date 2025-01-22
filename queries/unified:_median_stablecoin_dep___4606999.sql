-- part of a query repo
-- query name: Unified: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4606999


SELECT
    approx_percentile(stablecoinDeposit, 0.5) AS median
FROM
    (
        (
            SELECT
                stablecoinDeposit
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                duration > 86400 AND stablecoinDeposit > 50
        )
        UNION ALL
        (
            SELECT
                stablecoinDeposit
            FROM
                query_4596310 -- Legacy: Stream Creation Data
            WHERE
                duration > 86400 AND stablecoinDeposit > 50
        )
        UNION ALL
        (
            SELECT
                stablecoinDeposit
            FROM
                query_4606918 -- Flow: Deposit Data
            WHERE
                stablecoinDeposit > 50
        )
    )