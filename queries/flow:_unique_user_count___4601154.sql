-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Unique User Count
-- query link: https://dune.com/queries/4601154

SELECT COUNT(DISTINCT flow_user)
FROM
    (
        SELECT sender AS flow_user
        FROM query_4596391 -- Unified: Flow Stream Creation Data
        UNION ALL
        SELECT recipient AS flow_user
        FROM query_4596391 -- Unified: Flow Stream Creation Data
    )
