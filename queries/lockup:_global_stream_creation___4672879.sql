-- part of a query repo
-- query name: Lockup: Global Stream Creation Data
-- query link: https://dune.com/queries/4672879


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
FROM query_4580489 -- Lockup: Stream Creation Data 1

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
FROM query_4672652 -- Lockup: Stream Creation Data 2
