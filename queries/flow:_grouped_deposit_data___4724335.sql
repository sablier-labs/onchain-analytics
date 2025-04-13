-- part of a query repo
-- query name: Flow: Data for Deposits per Stream
-- query link: https://dune.com/queries/4724335


SELECT
    chain,
    contract_address,
    release_version,
    streamid,
    token,
    SUM(amount) AS total_deposit
FROM query_4606918 -- Flow: Data for Deposits
GROUP BY chain, contract_address, release_version, streamid, token;
