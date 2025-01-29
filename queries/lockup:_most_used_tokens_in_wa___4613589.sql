-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Most Used Tokens in Warm Streams
-- query link: https://dune.com/queries/4613589

SELECT
    q.chain,
    t.symbol,
    q.token,
    COUNT(q.token) AS number_of_streams
FROM
    query_4580489 AS q
LEFT JOIN
    tokens.erc20 AS t
    ON
        q.token = t.contract_address
        AND q.chain = t.blockchain
WHERE
    t.symbol IS NOT NULL
    AND FROM_UNIXTIME(CAST(q.starttime AS double)) < NOW()
    AND FROM_UNIXTIME(CAST(q.endtime AS double)) > NOW()
GROUP BY
    q.chain, q.token, t.symbol
ORDER BY
    number_of_streams DESC
LIMIT
    20;
