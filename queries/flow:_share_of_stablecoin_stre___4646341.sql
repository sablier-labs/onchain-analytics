-- part of a query repo
-- query name: Flow: Share of Stablecoin Streams
-- query link: https://dune.com/queries/4646341


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4596391 -- Flow: Stream Creation Data
            WHERE
                "stablecoinRatePerSecond" > 0
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4596391 -- Flow: Stream Creation Data
        )
    ) * 100
