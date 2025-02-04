-- part of a query repo
-- query name: Lockup: Most Used Stablecoins
-- query link: https://dune.com/queries/4666198


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
    AND q.stablecoin_deposit > 0
GROUP BY
    q.chain, q.token, t.symbol
ORDER BY
    number_of_streams DESC
