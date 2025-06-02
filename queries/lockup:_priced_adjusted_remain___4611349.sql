-- part of a query repo
-- query name: Lockup: Priced Adjusted Remaining Balances
-- query link: https://dune.com/queries/4611349
WITH latest_prices AS (
    SELECT
        contract_address,
        blockchain,
        symbol,
        price,
        timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY
                contract_address,
                blockchain
            ORDER BY
                timestamp DESC
        ) AS price_rank
    FROM
        prices.day
),

balance_with_price AS (
    SELECT
        q.chain,
        q.streamid,
        q.token,
        q.deposit,
        q.withdrawn_amount,
        q.adjusted_remaining_balance,
        lp.price,
        lp.timestamp AS price_timestamp,
        lp.symbol,
        q.adjusted_remaining_balance * lp.price AS remaining_balance_value
    FROM
        query_4611374 AS q -- Lockup: Adjusted Remaining Balances
    LEFT JOIN latest_prices AS lp
        ON
            q.token = lp.contract_address
            AND q.chain = lp.blockchain
    WHERE
        lp.price_rank = 1
        AND UPPER(CAST(token AS varchar(42))) NOT IN (
            '0X1F557FB2AA33DCE484902695CA1374F413875519',
            '0X5AC34C53A04B9AAA0BF047E7291FB4E8A48F2A18',
            '0X3638C9E50437F00AE53A649697F288BA68888CC1',
            '0X0A7B751FCDBBAA8BB988B9217AD5FB5CFE7BF7A0',
            '0XF64265E65C4529879A7ABF467E00D39E39C0B0DA',
            '0XC75C635C1F5E21D23EC8592CB37503B82A7EF942'
        )
)

SELECT
    chain,
    streamid,
    token,
    deposit,
    withdrawn_amount,
    adjusted_remaining_balance,
    price,
    price_timestamp,
    symbol,
    remaining_balance_value
FROM
    balance_with_price;
