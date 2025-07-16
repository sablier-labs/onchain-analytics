-- part of a query repo
-- query name: Flow: Data for Withdrawals
-- query link: https://dune.com/queries/4724176


SELECT
    chain,
    contract_address,
    evt_tx_hash,
    evt_tx_from,
    evt_tx_to,
    evt_block_time,
    evt_block_number,
    caller,
    protocolfeeamount,
    streamid,
    "to",
    token,
    'v1.0' AS release_version,
    withdrawamount
FROM sablier_flow_v1_0_multichain.sablierflow_evt_withdrawfromflowstream

UNION ALL

SELECT
    chain,
    contract_address,
    evt_tx_hash,
    evt_tx_from,
    evt_tx_to,
    evt_block_time,
    evt_block_number,
    caller,
    protocolfeeamount,
    streamid,
    "to",
    token,
    'v1.1' AS release_version,
    withdrawamount
FROM
    sablier_flow_v1_1_multichain.sablierflow_evt_withdrawfromflowstream
