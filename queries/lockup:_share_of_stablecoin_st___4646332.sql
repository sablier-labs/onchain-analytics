-- part of a query repo
-- query name: Lockup: Share of Stablecoin Streams
-- query link: https://dune.com/queries/4646332


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Global Stream Creation Data
            WHERE
                stablecoin_deposit > 0
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Global Stream Creation Data
        )
    ) * 100
