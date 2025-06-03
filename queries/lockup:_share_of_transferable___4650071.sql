-- part of a query repo
-- query name: Lockup: Share of Transferable Streams
-- query link: https://dune.com/queries/4650071


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Data for Creations - Chunk 1
            WHERE
                transferable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4580489 -- Lockup: Data for Creations - Chunk 1
        )
    ) * 100
