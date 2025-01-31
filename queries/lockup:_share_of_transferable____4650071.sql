-- part of a query repo
-- query name: Lockup: Share of Transferable Streams
-- query link: https://dune.com/queries/4650071


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
            WHERE
                transferable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
        )
    ) * 100
