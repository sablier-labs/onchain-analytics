-- part of a query repo
-- query name: Unified: Share of Streams Received by Safe Wallets
-- query link: https://dune.com/queries/4736107


SELECT
    (
        (
            SELECT CAST(matching_users AS DOUBLE)
            FROM
                query_4736093
        ) -- Unified: Stream Count Received by Safe Wallets
        / (
            SELECT CAST(stream_creation_count AS DOUBLE)
            FROM
                query_4600695
        ) -- Unified: Stream Creation Count
    ) * 100
