-- part of a query repo
-- query name: Unified: Share of Streams Received by Safe Users
-- query link: https://dune.com/queries/4736107


SELECT
    (
        (
            SELECT CAST(matching_users AS DOUBLE)
            FROM
                query_4736093
        ) -- Unified: Stream Count Received by Safe Users
        / (
            SELECT CAST(stream_creation_count AS DOUBLE)
            FROM
                query_4600695
        ) -- Unified: Stream Creation Count
    ) * 100
