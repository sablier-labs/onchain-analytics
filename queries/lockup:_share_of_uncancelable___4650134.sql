-- part of a query repo
-- query name: Lockup: Share of Uncancelable Streams
-- query link: https://dune.com/queries/4650134


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                cancelable = false
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
        )
    ) * 100
