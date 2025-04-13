-- part of a query repo
-- query name: Lockup: Daily Withdrawal Count
-- query link: https://dune.com/queries/4719563


SELECT
    COUNT(*) AS number_of_withdrawals,
    DATE_TRUNC('day', evt_block_time) AS evt_day
FROM
    (
        SELECT
            w.*,
            c.sender
        FROM
            sablier_lockup_v2_0_multichain.sablierlockup_evt_withdrawfromlockupstream AS w
        INNER JOIN query_4672652
            AS c ON w.chain = c.chain
        AND w.contract_address = c.contract_address
        AND w.streamid = c.streamid
        AND w.token = c.token
    )
WHERE
    sender IN ({{ addresses }}) -- Comma-separated list of sender or campaign addresses
GROUP BY
    DATE_TRUNC('day', evt_block_time)
