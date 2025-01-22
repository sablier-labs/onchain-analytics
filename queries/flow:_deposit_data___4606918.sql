-- part of a query repo
-- query name: Flow: Deposit Data
-- query link: https://dune.com/queries/4606918


SELECT 
    t1.chain,
    t1.contract_address,
    t1.evt_tx_hash,
    t1.evt_tx_from,
    t1.evt_tx_to,
    t1.evt_tx_index,
    t1.evt_index,
    t1.evt_block_time,
    t1.evt_block_number,
    t1.evt_block_date,
    t1.streamId,
    t1.funder,
    t1.amount,
    t2.asset
FROM 
    sablier_flow_v1_0_multichain.sablierflow_evt_depositflowstream AS t1
LEFT JOIN 
    query_4596391 AS t2 -- Flow: Stream Creation Data
ON 
    t1.streamId = t2.streamId AND t1.chain = t2.chain;