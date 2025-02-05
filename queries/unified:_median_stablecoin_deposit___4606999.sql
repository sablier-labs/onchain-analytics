-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4606999

SELECT approx_percentile(STABLECOIN_DEPOSIT, 0.5) AS MEDIAN
FROM
    (
        (
            SELECT STABLECOIN_DEPOSIT
            FROM
                QUERY_4580489 -- Lockup: Global Stream Creation Data
            WHERE
                DURATION > 86400 AND STABLECOIN_DEPOSIT > 50
        )
        UNION ALL
        (
            SELECT STABLECOIN_DEPOSIT
            FROM
                QUERY_4596310 -- Legacy: Stream Creation Data
            WHERE
                DURATION > 86400 AND STABLECOIN_DEPOSIT > 50
        )
        UNION ALL
        (
            SELECT STABLECOIN_DEPOSIT
            FROM
                QUERY_4606918 -- Flow: Deposit Data
            WHERE
                STABLECOIN_DEPOSIT > 50
        )
    )
