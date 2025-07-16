-- part of a query repo
-- query name: Lockup: Share of Cancelable Streams
-- query link: https://dune.com/queries/4650078


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                cancelable = true
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
        )
    ) * 100
