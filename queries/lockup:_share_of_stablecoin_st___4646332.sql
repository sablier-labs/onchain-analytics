-- part of a query repo
-- query name: Lockup: Share of Stablecoin Streams
-- query link: https://dune.com/queries/4646332


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                "stablecoinDeposit" > 0
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
        )
    ) * 100
