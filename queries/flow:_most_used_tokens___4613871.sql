-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Flow: Most Used Tokens
-- query link: https://dune.com/queries/4613871

SELECT
    q.chain,
    t.symbol,
    q.token,
    COUNT(q.token) AS number_of_streams
FROM
    query_4596391 AS q -- Flow: Data for Creations
INNER JOIN
    tokens.erc20 AS t
    ON
        q.token = t.contract_address
        AND q.chain = t.blockchain
WHERE
    t.symbol IS NOT NULL
GROUP BY
    q.chain, q.token, t.symbol
ORDER BY
    number_of_streams DESC
LIMIT
    20;
