-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Median Stablecoin Deposit
-- query link: https://dune.com/queries/4606999

SELECT approx_percentile(stablecoin_deposit, 0.5) AS median
FROM
    (
        (
            SELECT stablecoin_deposit
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                duration > 86400 AND stablecoin_deposit > 50
        )
        UNION ALL
        (
            SELECT stablecoin_deposit
            FROM
                query_4596310 -- Legacy: Data for Creations
            WHERE
                duration > 86400 AND stablecoin_deposit > 50
        )
        UNION ALL
        (
            SELECT stablecoin_deposit
            FROM
                query_4606918 -- Flow: Data for Deposits
            WHERE
                stablecoin_deposit > 50
        )
    )
