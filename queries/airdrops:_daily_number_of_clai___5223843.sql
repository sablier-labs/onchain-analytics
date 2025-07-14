-- part of a query repo
-- query name: Airdrops: Daily Number of Claims
-- query link: https://dune.com/queries/5223843


SELECT block_date, COUNT(tx_hash) AS instant_claim_count
FROM (
    SELECT t1.block_date, t1.tx_hash
    FROM
        ethereum.logs AS t1
    INNER JOIN ethereum.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        abstract.logs AS t1
    INNER JOIN abstract.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        arbitrum.logs AS t1
    INNER JOIN arbitrum.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        avalanche_c.logs AS t1
    INNER JOIN avalanche_c.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        base.logs AS t1
    INNER JOIN base.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        berachain.logs AS t1
    INNER JOIN berachain.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        blast.logs AS t1
    INNER JOIN blast.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        bnb.logs AS t1
    INNER JOIN bnb.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        gnosis.logs AS t1
    INNER JOIN gnosis.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        linea.logs AS t1
    INNER JOIN linea.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        "mode".logs AS t1
    INNER JOIN "mode".transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        optimism.logs AS t1
    INNER JOIN optimism.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        polygon.logs AS t1
    INNER JOIN polgyon.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        scroll.logs AS t1
    INNER JOIN scroll.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
    UNION ALL
    SELECT t1.block_date, t1.tx_hash
    FROM
        zksync.logs AS t1
    INNER JOIN zksync.transactions AS t2 ON t1.tx_hash = t2.hash
    WHERE
        (
            t1.topic0 = 0x28b58397e03322f670d6b223cc863f8c148e368b8b615412e6798a641a22842d
            OR t1.topic0 = 0x1dcd2362ae467d43bf31cbcac0526c0958b23eb063e011ab49a5179c839ed9a9
        )
)
GROUP BY block_date
ORDER BY block_date
