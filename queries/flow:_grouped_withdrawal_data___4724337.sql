-- part of a query repo
-- query name: Flow: Grouped Withdrawal Data
-- query link: https://dune.com/queries/4724337


SELECT
    chain,
    contract_address,
    release_version,
    streamid,
    token,
    SUM(withdrawamount) AS total_withdraw
FROM query_4724176 -- Flow: Withdrawal Data
GROUP BY chain, contract_address, release_version, streamid, token;
