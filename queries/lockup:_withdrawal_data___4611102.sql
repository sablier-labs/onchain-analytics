-- part of a query repo
-- query name: Lockup: Data for Withdrawals
-- query link: https://dune.com/queries/4611102


SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.1' AS release_version
FROM
    sablier_v2_1_multichain.sablierv2lockuplinear_evt_withdrawfromlockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.1' AS release_version
FROM
    sablier_v2_1_multichain.sablierv2lockupdynamic_evt_withdrawfromlockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.1' AS release_version
FROM
    sablier_v2_2_multichain.sablierv2lockuplinear_evt_withdrawfromlockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.2' AS release_version
FROM
    sablier_v2_2_multichain.sablierv2lockupdynamic_evt_withdrawfromlockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.2' AS release_version
FROM
    sablier_v2_2_multichain.sablierv2lockuptranched_evt_withdrawfromlockupstream

UNION ALL
SELECT
    chain,
    contract_address,
    evt_block_time,
    streamid,
    asset AS token,
    amount,
    'v1.3' AS release_version
FROM
    sablier_v2_2_multichain.sablierv2lockuptranched_evt_withdrawfromlockupstream
