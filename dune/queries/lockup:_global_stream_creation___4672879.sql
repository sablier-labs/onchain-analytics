-- part of a query repo
-- query name: Lockup: Data for Creations
-- query link: https://dune.com/queries/4672879

-- We need to split this query into two separate chunks because Dune enforces a limit on the size of queries --

SELECT
    chain,
    token,
    broker,
    cancelable,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    transferable,
    contract AS category,
    release_version,
    shape,
    stablecoin_deposit,
    starttime,
    endtime,
    duration,
    cliffduration,
    deposit,
    protocolfee,
    brokerfee
FROM query_4580489 -- Lockup: Data for Creations - Chunk 1

UNION ALL

SELECT
    chain,
    token,
    broker,
    cancelable,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    transferable,
    category,
    release_version,
    shape,
    stablecoin_deposit,
    starttime,
    endtime,
    duration,
    cliffduration,
    deposit,
    protocolfee,
    brokerfee
FROM query_4672652 -- Lockup: Data for Creations - Chunk 2
