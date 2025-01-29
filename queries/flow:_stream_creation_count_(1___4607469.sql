-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Stream Creation Count (1 Month)
-- query link: https://dune.com/queries/4607469

SELECT COUNT(*)
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    evt_block_time >= DATE_TRUNC('day', CURRENT_DATE) - INTERVAL '1' MONTH
