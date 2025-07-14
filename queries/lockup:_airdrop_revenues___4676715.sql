-- part of a query repo
-- query name: Lockup: Airdrop Revenues
-- query link: https://dune.com/queries/4676715


SELECT
    'Ethereum' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    ethereum.logs AS t1
INNER JOIN ethereum.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Base' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    base.logs AS t1
INNER JOIN base.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Arbitrum' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    arbitrum.logs AS t1
INNER JOIN arbitrum.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Optimism' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    optimism.logs AS t1
INNER JOIN optimism.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Linea' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    linea.logs AS t1
INNER JOIN linea.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'zkSync' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    zksync.logs AS t1
INNER JOIN zksync.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Scroll' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    scroll.logs AS t1
INNER JOIN scroll.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Abstract' AS chain,
    'ETH' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    abstract.logs AS t1
INNER JOIN abstract.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Avalanche' AS chain,
    'AVAX' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    avalanche_c.logs AS t1
INNER JOIN avalanche_c.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Polygon' AS chain,
    'POL' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    polygon.logs AS t1
INNER JOIN polygon.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'BNB Chain' AS chain,
    'BNB' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    bnb.logs AS t1
INNER JOIN bnb.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
UNION ALL
SELECT
    'Gnosis Chain' AS chain,
    'GNO' AS currency,
    t1.block_time,
    COALESCE(t2.value, 0) / 1e18 AS airdrop_fee
FROM
    gnosis.logs AS t1
INNER JOIN gnosis.transactions AS t2 ON t1.tx_hash = t2.hash
WHERE
    (
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
        AND t2.value > 0
    )
