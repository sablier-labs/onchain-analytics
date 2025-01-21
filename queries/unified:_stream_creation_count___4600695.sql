-- part of a query repo
-- query name: Unified: Stream Creation Count
-- query link: https://dune.com/queries/4600695


SELECT
    (
        (
            SELECT
                COUNT(*)
            FROM
                query_4580489 -- Lockup: Stream Creation Data
        ) + (
            SELECT
                COUNT(*)
            FROM
                query_4596310 -- Legacy: Stream Creation Data
        ) + (
            SELECT
                COUNT(*)
            FROM
                query_4596391 -- Flow: Stream Creation Data
        )
    ) AS stream_creation_count
S stream_creation_count
