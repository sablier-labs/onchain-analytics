-- part of a query repo
-- query name: Lockup: Withdrawal Count
-- query link: https://dune.com/queries/4719220


SELECT
    COUNT(*) AS number_of_withdrawals
FROM
    (
        SELECT
            w.*,
            c.sender
        FROM
            sablier_lockup_v2_0_multichain.sablierlockup_evt_withdrawfromlockupstream w
            JOIN query_4672652 c ON w.chain = c.chain -- Lockup: Stream Creation Data 2
            AND w.contract_address = c.contract_address
            AND w.streamId = c.streamId
            AND w.token = c.token
    )
WHERE
    sender IN ({{Sender/Campaign Addresses}})
    AND evt_block_time > CAST('{{Start Date}}' AS TIMESTAMP)
    AND evt_block_time < CAST('{{End Date}}' AS TIMESTAMP)