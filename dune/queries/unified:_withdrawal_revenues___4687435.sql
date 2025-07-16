-- part of a query repo
-- query name: Unified: Withdrawal Revenues
-- query link: https://dune.com/queries/4687435


SELECT
    'Ethereum' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    ethereum.traces
WHERE
    (
        "from" = 0x7c01aa3783577e15fd7e272443d44b92d5b21056 -- Lockup v2.0
        OR "from" = 0x3df2aaede81d2f6b261f79047517713b8e844e04 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Abstract' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    abstract.traces
WHERE
    (
        "from" = 0x14eb4ab47b2ec2a71763eaba202a252e176fae88 -- Lockup v2.0
        OR "from" = 0x555b0766f494c641bb522086da4e728ac08c1420 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Arbitrum' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    arbitrum.traces
WHERE
    (
        "from" = 0x467d5bf8cfa1a5f99328fbdcb9c751c78934b725 -- Lockup v2.0
        OR "from" = 0x87cf87ec5de33deb4a88787065373563ba85ee72 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Avalanche' AS chain,
    'AVAX' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    avalanche_c.traces
WHERE
    (
        "from" = 0x3c81bbbe72ef8ef3fb1d19b0bd6310ad0dd27e82 -- Lockup v2.0
        OR "from" = 0xac7cb985d4022a5ebd4a385374ac3d3b487b3c63 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Base' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    base.traces
WHERE
    (
        "from" = 0xb5d78dd3276325f5faf3106cc4acc56e28e0fe3b -- Lockup v2.0
        OR "from" = 0x6fe93c7f6cd1dc394e71591e3c42715be7180a6a -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Blast' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    blast.traces
WHERE
    (
        "from" = 0xdbb6e9653d7e41766712db22eb08ed3f21009fdd -- Lockup v2.0
        OR "from" = 0x16b50eb5eaef0366f1a4da594e2a8c8943a297e0 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'BNB Chain' AS chain,
    'BNB' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    bnb.traces
WHERE
    (
        "from" = 0x6e0bad2c077d699841f1929b45bfb93fafbed395 -- Lockup v2.0
        OR "from" = 0x4c4610af3f3861ec99b6f6f8066c03e4c3a0e023 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Gnosis Chain' AS chain,
    'xDAI' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    gnosis.traces
WHERE
    (
        "from" = 0x007af5dc7b1caa66cf7ebcc01e2e6ba4d55d3e92 -- Lockup v2.0
        OR "from" = 0x34bc0c2bf1f2da51c65cd821ba4133afcacdb8f5 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Linea' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    linea.traces
WHERE
    (
        "from" = 0x6964252561e8762dd10267176eac5078b6291e51 -- Lockup v2.0
        OR "from" = 0xefc6e4c7dc5faa0cfbfebb5e04ea7cd47f64012f -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Optimism' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    optimism.traces
WHERE
    (
        "from" = 0x822e9c4852e978104d82f0f785bfa663c2b700c1 -- Lockup v2.0
        OR "from" = 0xc5612fea2d370127ac67048115bd6b1df7b7f7c0 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Polygon' AS chain,
    'POL' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    polygon.traces
WHERE
    (
        "from" = 0xe0bfe071da104e571298f8b6e0fce44c512c1ff4 -- Lockup v2.0
        OR "from" = 0x3e5c4130ea7cfbd364fa5f170289d697865ca94b -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'Scroll' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    scroll.traces
WHERE
    (
        "from" = 0xcb0b1f1d116ed62135848d8c90eb61afda936da8 -- Lockup v2.0
        OR "from" = 0xc4f104ce12cb12484ff67cf0c4bd0561f0014ec2 -- Flow v1.1
    )
    AND "value" > 0
UNION ALL
SELECT
    'zkSync' AS chain,
    'ETH' AS currency,
    block_time,
    "value" / 1e18 AS withdrawal_fee
FROM
    zksync.traces
WHERE
    (
        "from" = 0x7bccb3595aa81dbe8a69dd8c46f5c2a3cf76594a -- Lockup v2.0
        OR "from" = 0xe3747379bf7282e0ab5389a63ea053a5256042df -- Flow v1.1
    )
    AND "value" > 0
