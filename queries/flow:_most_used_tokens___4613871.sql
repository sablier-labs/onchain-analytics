-- part of a query repo
-- query name: Flow: Most Used Tokens
-- query link: https://dune.com/queries/4613871


SELECT
    q.chain,
    q.asset,
    t.symbol,
    COUNT(q.asset) AS number_of_streams
FROM
    query_4596391 AS q -- Flow: Stream Creation Data
LEFT JOIN
    tokens.erc20 AS t
ON
    q.asset = t.contract_address
    AND q.chain = t.blockchain
WHERE
    t.symbol IS NOT NULL
GROUP BY
    q.chain, q.asset, t.symbol
ORDER BY
    number_of_streams DESC
LIMIT
    20;