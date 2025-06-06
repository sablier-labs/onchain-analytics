-- part of a query repo
-- query name: Flow: Data for Withdrawals per Stream
-- query link: https://dune.com/queries/4724337


SELECT
    chain,
    contract_address,
    release_version,
    streamid,
    token,
    SUM(withdrawamount) AS total_withdraw
FROM query_4724176 -- Flow: Data for Withdrawals
GROUP BY chain, contract_address, release_version, streamid, token;
