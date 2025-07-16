-- part of a query repo
-- query name: Flow: Most Used Stablecoins
-- query link: https://dune.com/queries/4666321


SELECT
    q.chain,
    t.symbol,
    q.token,
    COUNT(q.token) AS number_of_deposits
FROM
    query_4606918 AS q
INNER JOIN
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
    number_of_deposits DESC
