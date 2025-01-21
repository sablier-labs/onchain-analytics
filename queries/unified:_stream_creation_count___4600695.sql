-- part of a query repo
-- query name: Unified: Stream Creation Count
-- query link: https://dune.com/queries/4600695


SELECT
    (
        (
            SELECT
                COUNT(*)
            FROM
                query_4580489 -- Unified: Lockup Stream Creation Data
        ) + (
            SELECT
                COUNT(*)
            FROM
                query_4596310 -- Unified: Legacy Stream Creation Data
        ) + (
            SELECT
                COUNT(*)
            FROM
                query_4596391 -- Unified: Flow Stream Creation Data
        )
    ) AS stream_creation_count
