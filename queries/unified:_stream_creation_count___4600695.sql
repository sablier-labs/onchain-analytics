-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Unified: Stream Creation Count
-- query link: https://dune.com/queries/4600695

SELECT
    (
        (
            SELECT COUNT(*)
            FROM
                query_4672879 -- Lockup: Data for Creations
        ) + (
            SELECT COUNT(*)
            FROM
                query_4596310 -- Legacy: Data for Creations
        ) + (
            SELECT COUNT(*)
            FROM
                query_4596391 -- Flow: Data for Creations
        )
    ) AS stream_creation_count
