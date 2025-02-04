-- part of a query repo
-- query name: Lockup: Remaining Balances (Accounted for Cancelations)
-- query link: https://dune.com/queries/4665542


SELECT
    q1.chain,
    q1.contract_address,
    q1.contract,
    q1.streamid,
    q1.token,
    q1.release_version,
    q1.deposit,
    q1.evt_block_time,
    q1.recipient,
    q1.withdrawn_amount,
    CASE
        WHEN q2.streamid IS NOT NULL THEN 0
        ELSE q1.remaining_balance
    END AS remaining_balance
FROM query_4611179 q1
LEFT JOIN query_4665451 q2
    ON
        q1.chain = q2.chain
        AND q1.streamid = q2.streamid
        AND q1.contract_address = q2.contract_address
        AND q1.token = q2.token
        AND q1.release_version = q2.release_version;
