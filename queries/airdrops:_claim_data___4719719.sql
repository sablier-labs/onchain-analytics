-- part of a query repo
-- query name: Airdrops: Data for Claims
-- query link: https://dune.com/queries/4719719


SELECT
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
    t1.block_time,
    contract_address
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
