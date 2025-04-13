-- part of a query repo
-- query name: Flow: Priced Adjusted Remaining Balances
-- query link: https://dune.com/queries/4724379


WITH
latest_prices AS (
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
        q.deposit_amount,
        q.withdrawn_amount,
        q.adjusted_remaining_balance,
        lp.price,
        lp.timestamp AS price_timestamp,
        lp.symbol,
        q.adjusted_remaining_balance * lp.price AS remaining_balance_value
    FROM
        query_4724366 q -- Lockup: Adjusted Remaining Balances
    LEFT JOIN latest_prices lp
        ON
            q.token = lp.contract_address
            AND q.chain = lp.blockchain
    WHERE
        lp.price_rank = 1
        AND UPPER(CAST(token AS varchar(42))) NOT IN (
            '0X1F557FB2AA33DCE484902695CA1374F413875519',
            '0X5AC34C53A04B9AAA0BF047E7291FB4E8A48F2A18',
            '0X3638C9E50437F00AE53A649697F288BA68888CC1',
            '0X0A7B751FCDBBAA8BB988B9217AD5FB5CFE7BF7A0'
        )
)

SELECT
    chain,
    streamid,
    token,
    deposit_amount,
    withdrawn_amount,
    adjusted_remaining_balance,
    price,
    price_timestamp,
    symbol,
    remaining_balance_value
FROM
    balance_with_price;
