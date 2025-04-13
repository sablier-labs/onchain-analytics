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
            -- TODO: why query only v2?
            sablier_lockup_v2_0_multichain.sablierlockup_evt_withdrawfromlockupstream AS w
        INNER JOIN query_4672652
            AS c ON w.chain = c.chain -- Lockup: Stream Creation Data 2
        AND w.contract_address = c.contract_address
        AND w.streamid = c.streamid
        AND w.token = c.token
    )
WHERE
    sender IN ({{ addresses }}) -- Comma-separated list of sender or campaign addresses
    AND evt_block_time > CAST('{{ start_date }}' AS TIMESTAMP)
    AND evt_block_time < CAST('{{ end_date }}' AS TIMESTAMP)
