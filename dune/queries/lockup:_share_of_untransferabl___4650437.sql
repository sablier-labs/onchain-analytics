-- part of a query repo
-- query name: Lockup: Share of Untransferable Streams
-- query link: https://dune.com/queries/4650437


SELECT
    (
        (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
            WHERE
                transferable = false
        ) / (
            SELECT CAST(COUNT(*) AS DOUBLE)
            FROM
                query_4672879 -- Lockup: Data for Creations
        )
    ) * 100
