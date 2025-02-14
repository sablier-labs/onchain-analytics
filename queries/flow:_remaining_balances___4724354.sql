-- part of a query repo
-- query name: Flow: Remaining Balances
-- query link: https://dune.com/queries/4724354


SELECT
    t1.chain,
    t1.contract_address,
    t1.streamid,
    t1.token,
    t1.release_version,
    t1.total_deposit AS deposit_amount,
    COALESCE(t2.total_withdraw, 0) AS withdrawn_amount,
    CAST(t1.total_deposit AS double) - CAST(COALESCE(t2.total_withdraw, 0) AS double) AS remaining_balance
FROM
    query_4724335 t1 -- Flow: Grouped Deposit Data
LEFT JOIN
    query_4724337 -- Flow: Grouped Withdrawal Data
        t2 ON t1.chain = t2.chain
AND t1.contract_address = t2.contract_address
AND t1.streamid = t2.streamid
AND t1.release_version = t2.release_version
AND t1.token = t2.token
