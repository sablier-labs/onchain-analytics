-- part of a query repo
-- query name: Lockup: Adjusted Remaining Balances
-- query link: https://dune.com/queries/4611374


WITH adjusted_balances AS (
    SELECT
        q.chain,
        q.contract_address,
        q.streamid,
        q.token,
        q.deposit,
        q.withdrawn_amount,
        q.remaining_balance,
        t.decimals,
        q.remaining_balance / POWER(10, t.decimals) AS adjusted_remaining_balance
    FROM
        query_4611179 q -- Lockup: Remaining Balances
    LEFT JOIN
        tokens.erc20 t
        ON
            q.token = t.contract_address
            AND q.chain = t.blockchain
)

SELECT
    chain,
    contract_address,
    streamid,
    token,
    deposit,
    withdrawn_amount,
    remaining_balance,
    decimals,
    adjusted_remaining_balance
FROM
    adjusted_balances;
