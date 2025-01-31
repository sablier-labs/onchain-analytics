-- part of a query repo
-- query name: Lockup: Share of Cancelable Streams
-- query link: https://dune.com/queries/4650078


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                cancelable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
        )
    ) * 100