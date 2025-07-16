-- part of a query repo
-- query name: Lockup: Share of Uncancelable Streams
-- query link: https://dune.com/queries/4650134


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                cancelable = false
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
        )
    ) * 100
