-- part of a query repo
-- query name: Lockup: Remaining Balances
-- query link: https://dune.com/queries/4611179


SELECT
    t1.chain,
    t1.contract_address,
    t1.streamid,
    t1.token,
    t1.release_version,
    t1.deposit,
    t1.evt_block_time,
    t1.recipient,
    COALESCE(t2.total_amount, 0) AS withdrawn_amount,
    CAST(t1.deposit AS double) - CAST(COALESCE(t2.total_amount, 0) AS double) AS remaining_balance
FROM
    query_4672879 t1
LEFT JOIN
    query_4611255
        t2 ON t1.chain = t2.chain
AND t1.contract_address = t2.contract_address
AND t1.streamid = t2.streamid
AND t1.release_version = t2.release_version
AND t1.token = t2.token
