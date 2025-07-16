-- part of a query repo
-- query name: Lockup: Data for Cancellations
-- query link: https://dune.com/queries/4665451


SELECT
    chain,
    contract_address,
    'lockupLinear' AS contract,
    evt_block_time,
    streamid,
    asset AS token,
    'v1.1' AS release_version
FROM
    sablier_lockup_v1_1_multichain.sablierv2lockuplinear_evt_cancellockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    'lockupDynamic' AS contract,
    evt_block_time,
    streamid,
    asset AS token,
    'v1.1' AS release_version
FROM
    sablier_lockup_v1_1_multichain.sablierv2lockupdynamic_evt_cancellockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    'lockupLinear' AS contract,
    evt_block_time,
    streamid,
    asset AS token,
    'v1.1' AS release_version
FROM
    sablier_lockup_v1_2_multichain.sablierv2lockuplinear_evt_cancellockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    'lockupDynamic' AS contract,
    evt_block_time,
    streamid,
    asset AS token,
    'v1.2' AS release_version
FROM
    sablier_lockup_v1_2_multichain.sablierv2lockupdynamic_evt_cancellockupstream
UNION ALL
SELECT
    chain,
    contract_address,
    'lockupTranched' AS contract,
    evt_block_time,
    streamid,
    asset AS token,
    'v1.2' AS release_version
FROM
    sablier_lockup_v1_2_multichain.sablierv2lockuptranched_evt_cancellockupstream
