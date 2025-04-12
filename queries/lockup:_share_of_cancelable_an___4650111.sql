-- part of a query repo
-- query name: Lockup: Share of Cancelable and Transferable Streams
-- query link: https://dune.com/queries/4650111


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                cancelable = true AND transferable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
        )
    ) * 100
