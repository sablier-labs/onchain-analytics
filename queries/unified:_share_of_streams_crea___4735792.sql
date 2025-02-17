-- part of a query repo
-- query name: Unified: Share of Streams Created by Safe Wallets
-- query link: https://dune.com/queries/4735792


SELECT
    (
        (
            SELECT CAST(matching_users AS DOUBLE)
            FROM
                query_4735747
        ) -- Unified: Stream Count Created by Safe Wallets
        / (
            SELECT CAST(stream_creation_count AS DOUBLE)
            FROM
                query_4600695
        ) -- Unified: Stream Creation Count
    ) * 100
