-- part of a query repo
-- query name: Lockup: Daily Withdrawal Count
-- query link: https://dune.com/queries/4719563


SELECT
    COUNT(*) AS number_of_withdrawals,
    date_trunc('day', evt_block_time) AS evt_day
FROM
    (
        SELECT
            w.*,
            c.sender
        FROM
            sablier_lockup_v2_0_multichain.sablierlockup_evt_withdrawfromlockupstream w
            JOIN query_4672652 c ON w.chain = c.chain
            AND w.contract_address = c.contract_address
            AND w.streamId = c.streamId
            AND w.token = c.token
    )
WHERE
    sender IN ({{Sender/Campaign Addresses}})
GROUP BY
    date_trunc('day', evt_block_time)
