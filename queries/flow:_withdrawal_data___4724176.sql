-- part of a query repo
-- query name: Flow: Withdrawal Data
-- query link: https://dune.com/queries/4724176


SELECT
    chain,
    contract_address,
    evt_tx_hash,
    evt_tx_from,
    evt_tx_to,
    evt_tx_index,
    evt_block_time,
    evt_block_number,
    evt_block_date,
    caller,
    protocolfeeamount,
    streamid,
    "to",
    token,
    withdrawamount
FROM sablier_flow_v1_0_multichain.sablierflow_evt_withdrawfromflowstream

UNION ALL

SELECT
    chain,
    contract_address,
    evt_tx_hash,
    evt_tx_from,
    evt_tx_to,
    evt_tx_index,
    evt_block_time,
    evt_block_number,
    evt_block_date,
    caller,
    protocolfeeamount,
    streamid,
    "to",
    token,
    withdrawamount
FROM sablier_flow_v1_1_multichain.sablierflow_evt_withdrawfromflowstream
