-- part of a query repo
-- query name: Lockup: Share of Uncancelable and Transferable Streams
-- query link: https://dune.com/queries/4650093


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                cancelable = false AND transferable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
        )
    ) * 100
