-- part of a query repo
-- query name: Lockup: Most Used Tokens in Warm Streams
-- query link: https://dune.com/queries/4613589


SELECT
    q.chain,
    q.asset,
    t.symbol,
    COUNT(q.asset) AS number_of_streams
FROM
    query_4580489 AS q
LEFT JOIN
    tokens.erc20 AS t
ON
    q.asset = t.contract_address
    AND q.chain = t.blockchain
WHERE
    t.symbol IS NOT NULL
    AND from_unixtime(CAST(q.startTime AS double)) < now()
    AND from_unixtime(CAST(q.endTime AS double)) > now()
GROUP BY
    q.chain, q.asset, t.symbol
ORDER BY
    number_of_streams DESC
LIMIT
    20;