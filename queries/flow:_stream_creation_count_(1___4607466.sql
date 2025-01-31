-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Stream Creation Count (12 Months)
-- query link: https://dune.com/queries/4607466

SELECT COUNT(*)
FROM
    query_4596391 -- Flow: Stream Creation Data
WHERE
    evt_block_time >= DATE_TRUNC('day', CURRENT_DATE) - INTERVAL '12' MONTH
