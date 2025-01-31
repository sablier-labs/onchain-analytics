-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Lockup: Stream Creation Data
-- query link: https://dune.com/queries/4580489

-- Lockup v1.0: LockupLinear

SELECT
    asset AS token,
    broker,
    cancelable,
    chain,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    false AS transferable,
    'lockupLinear' AS contract,
    'v1.0' AS release_version,
    CASE
        WHEN
            cast(json_extract_scalar(range, '$.cliff') AS DOUBLE)
            - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
            = 0
            THEN 'linear'
        ELSE 'linear-cliff'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(range, '$.start') AS starttime,
    json_extract_scalar(range, '$.end') AS endtime,
    (
        cast(json_extract_scalar(range, '$.end') AS DOUBLE) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
    ) AS duration,
    cast(json_extract_scalar(range, '$.cliff') AS DOUBLE)
    - cast(json_extract_scalar(range, '$.start') AS DOUBLE) AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    json_extract_scalar(amounts, '$.protocolFee') AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_0_multichain.sablierv2lockuplinear_evt_createlockuplinearstream

UNION ALL

-- Lockup v1.0: LockupDynamic

SELECT
    asset AS token,
    broker,
    chain,
    cancelable,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    false AS transferable,
    'lockupDynamic' AS contract,
    'v1.0' AS release_version,
    CASE
        WHEN json_extract_scalar(segments[1], '$.exponent') = '3000000000000000000' THEN 'exponential'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[cardinality(segments)], '$.exponent') = '1000000000000000000'
            THEN 'traditional-unlock'
        WHEN cardinality(segments) < 3 THEN 'other'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000' THEN 'exponential-cliff'
        ELSE 'other'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6 -- 6 decimals
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18 -- 18 decimals
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(range, '$.start') AS starttime,
    json_extract_scalar(range, '$.end') AS endtime,
    (
        cast(json_extract_scalar(range, '$.end') AS DOUBLE) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
    ) AS duration,
    CASE
        WHEN cardinality(segments) < 3 THEN 0
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000'
            THEN cast(
                json_extract_scalar(segments[2], '$.milestone') AS DOUBLE
            ) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
        ELSE 0
    END AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    json_extract_scalar(amounts, '$.protocolFee') AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_0_multichain."SablierV2LockupDynamic_evt_CreateLockupDynamicStream"

UNION ALL

-- Lockup v1.1: LockupLinear

SELECT
    broker,
    chain,
    cancelable,
    'lockupLinear' AS contract,
    contract_address,
    transferable,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    'v1.1' AS release_version,
    sender,
    streamid,
    asset AS token,
    CASE
        WHEN
            cast(json_extract_scalar(range, '$.cliff') AS DOUBLE)
            - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
            = 0
            THEN 'linear'
        ELSE 'linear-cliff'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(range, '$.start') AS starttime,
    json_extract_scalar(range, '$.end') AS endtime,
    (
        cast(json_extract_scalar(range, '$.end') AS DOUBLE) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
    ) AS duration,
    cast(json_extract_scalar(range, '$.cliff') AS DOUBLE)
    - cast(json_extract_scalar(range, '$.start') AS DOUBLE) AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    json_extract_scalar(amounts, '$.protocolFee') AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_1_multichain.sablierv2lockuplinear_evt_createlockuplinearstream

UNION ALL

-- Lockup v1.1: LockupDynamic

SELECT
    asset AS token,
    broker,
    cancelable,
    chain,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    transferable,
    'lockupDynamic' AS contract,
    'v1.1' AS release_version,
    CASE
        WHEN json_extract_scalar(segments[1], '$.exponent') = '3000000000000000000' THEN 'exponential'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[cardinality(segments)], '$.exponent') = '1000000000000000000'
            THEN 'traditional-unlock'
        WHEN cardinality(segments) < 3 THEN 'other'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000' THEN 'exponential-cliff'
        ELSE 'other'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(range, '$.start') AS starttime,
    json_extract_scalar(range, '$.end') AS endtime,
    (
        cast(json_extract_scalar(range, '$.end') AS DOUBLE) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
    ) AS duration,
    CASE
        WHEN cardinality(segments) < 3 THEN 0
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000'
            THEN cast(
                json_extract_scalar(segments[2], '$.milestone') AS DOUBLE
            ) - cast(json_extract_scalar(range, '$.start') AS DOUBLE)
        ELSE 0
    END AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    json_extract_scalar(amounts, '$.protocolFee') AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_1_multichain."SablierV2LockupDynamic_evt_CreateLockupDynamicStream"

UNION ALL

-- Lockup v1.2: LockupLinear

SELECT
    asset AS token,
    broker,
    chain,
    cancelable,
    transferable,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    'lockupLinear' AS contract,
    'v1.2' AS release_version,
    CASE
        WHEN cast(
            json_extract_scalar(timestamps, '$.cliff') AS DOUBLE
        ) = 0 THEN 'linear'
        ELSE 'linear-cliff'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(timestamps, '$.start') AS starttime,
    json_extract_scalar(timestamps, '$.end') AS endtime,
    (
        cast(
            json_extract_scalar(timestamps, '$.end') AS DOUBLE
        ) - cast(
            json_extract_scalar(timestamps, '$.start') AS DOUBLE
        )
    ) AS duration,
    CASE
        WHEN cast(
            json_extract_scalar(timestamps, '$.cliff') AS DOUBLE
        ) = 0 THEN 0
        ELSE cast(
            json_extract_scalar(timestamps, '$.cliff') AS DOUBLE
        ) - cast(
            json_extract_scalar(timestamps, '$.start') AS DOUBLE
        )
    END AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    '0' AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_2_multichain.sablierv2lockuplinear_evt_createlockuplinearstream

UNION ALL

-- Lockup v1.2: LockupDynamic


SELECT
    asset AS token,
    broker,
    cancelable,
    chain,
    contract_address,
    transferable,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    'lockupDynamic' AS contract,
    'v1.2' AS release_version,
    CASE
        WHEN json_extract_scalar(segments[1], '$.exponent') = '3000000000000000000' THEN 'exponential'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[cardinality(segments)], '$.exponent') = '1000000000000000000'
            THEN 'traditional-unlock'
        WHEN cardinality(segments) < 3 THEN 'other'
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000' THEN 'exponential-cliff'
        ELSE 'other'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(timestamps, '$.start') AS starttime,
    json_extract_scalar(timestamps, '$.end') AS endtime,
    (
        cast(
            json_extract_scalar(timestamps, '$.end') AS DOUBLE
        ) - cast(
            json_extract_scalar(timestamps, '$.start') AS DOUBLE
        )
    ) AS duration,
    CASE
        WHEN cardinality(segments) < 3 THEN 0
        WHEN
            json_extract_scalar(segments[1], '$.amount') = '0'
            AND json_extract_scalar(segments[1], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[2], '$.exponent') = '1000000000000000000'
            AND json_extract_scalar(segments[3], '$.exponent') = '3000000000000000000'
            THEN cast(
                json_extract_scalar(segments[2], '$.milestone') AS DOUBLE
            ) - cast(
                json_extract_scalar(timestamps, '$.start') AS DOUBLE
            )
        ELSE 0
    END AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    '0' AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_2_multichain."SablierV2LockupDynamic_evt_CreateLockupDynamicStream"

UNION ALL

-- Lockup v1.2: LockupTranched

SELECT
    asset AS token,
    broker,
    cancelable,
    chain,
    contract_address,
    evt_block_number,
    evt_block_time,
    evt_index,
    evt_tx_hash,
    funder,
    recipient,
    sender,
    streamid,
    transferable,
    'lockupTranched' AS contract,
    'v1.2' AS release_version,
    CASE
        WHEN cardinality(tranches) = 1 THEN 'timelock'
        WHEN cast(
            json_extract_scalar(tranches[2], '$.timestamp') AS DOUBLE
        ) - cast(
            json_extract_scalar(tranches[1], '$.timestamp') AS DOUBLE
        ) IN (2419200, 2592000, 2678400) THEN 'monthly-unlocks'
        ELSE 'unlock-in-steps'
    END AS shape,
    CASE
        WHEN
            token IN (
                0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, -- Ethereum USDC
                0x1d17cbcf0d6d143135ae902365d2e5e2a16538d4, -- zkSync USDC
                0x0b2c639c533813f4aa9d7837caf62653d097ff85, -- Optimism USDC
                0x833589fcd6edb6e08f4c7c32d4f71b54bda02913, -- Base USDC
                0xaf88d065e77c8cc2239327c5edb3a432268e5831, -- Arbitrum USDC
                0x3c499c542cef5e3811e1192ce70d8cc03d5c3359, -- Polygon POS USDC
                0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e, -- Avalanche USDC
                0xdac17f958d2ee523a2206206994597c13d831ec7, -- Ethereum USDT
                0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7, -- Avalanche USDT
                0xa7d7079b0fead91f3e65f86e8915cb59c1a4c664, -- Avalanche USDC.e
                0x7f5c764cbc14f9669b88837ca1490cca17c31607, -- Optimism USDC.e
                0xff970a61a04b1ca14834a43f5de4533ebddb5cc8, -- Arbitrum USDC.e
                0x2791bca1f2de4661ed88a30c99a7a9449aa84174, -- Polygon POS USDC.e
                0x6c3ea9036406852006290770bedfcaba0e23a0e8 -- Ethereum PYUSD
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e6
        WHEN
            token IN (
                0xdc035d45d973e3ec169d2276ddab16f1e407384f, -- Ethereum USDS
                0x820c137fa70c8691f0e44dc420a5e53c168921dc, -- Base USDS
                0x57ab1ec28d129707052df4df418d58a2d46d5f51, -- Ethereum SUSD
                0xa970af1a584579b618be4d69ad6f73459d112f95, -- Arbitrum One SUSD
                0xe9e7cea3dedca5984780bafc599bd69add087d56, -- BNB BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Optimism BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Polygon POS BUSD
                0x9c9e5fd8bbc25984b178fdce6117defa39d2db39, -- Avalanche BUSD
                0x4c9edd5852cd905f086c759e8383e09bff1e68b3, -- Ethereum USDE
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- Ethereum FDUSD
                0xc5f0f7b66764f6ec8c8dff7ba683102295e16409, -- BNB FDUSD
                0x0000000000085d4780b73119b644ae5ecd22b376, -- Ethereum TUSD
                0x40af3827f39d0eacbf4a168f8d4ee67c121d11c9, -- BNB TUSD
                0x1c20e891bab6b1727d14da358fae2984ed9b59eb, -- Avalanche TUSD
                0x73a15fed60bf67631dc6cd7bc5b6e8da8190acf5, -- Ethereum USD0
                0x35f1c5cb7fb977e669fd244c567da99d8a3a6850, -- Arbitrum One USD0
                0x853d955acef822db058eb8505911ed77f175b99e, -- Ethereum FRAX
                0x2e3d870790dc77a83dd1d18184acc7439a53f475, -- Optimism FRAX
                0x17fc002b466eec40dae837fc4be5c67993ddbd6f, -- Arbitrum FRAX
                0x45c32fa6df82ead1e2ef74d17b76547eddfaff89, -- Polygon POS FRAX
                0xd24c2ad096400b6fbcd2ad8b24e7acbc21a1da64, -- Avalanche FRAX
                0x90c97f71e18723b0cf0dfa30ee176ab653e89f40, -- BNB FRAX
                0xbdc7c08592ee4aa51d06c27ee23d5087d65adbcd, -- Ethereum USDL
                0x7f850b0ab1988dd17b69ac564c1e2857949e4dee, -- Arbitrum One USDL
                0x8e870d67f660d95d5be530380d0ec0bd388289e1, -- Ethereum USDP
                0x6b175474e89094c44da98b954eedeac495271d0f, -- Ethereum DAI
                0x8f3cf7ad23cd3cadbd9735aff958023239c6a063, -- Polygon POS DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Arbitrum One DAI
                0xda10009cbd5d07dd0cecc66161fc93d7c9000da1, -- Optimism DAI
                0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3 -- BNB DAI
            )
            THEN cast(json_extract_scalar(amounts, '$.deposit') AS DOUBLE) / 1e18
        ELSE 0
    END AS stablecoin_deposit,
    json_extract_scalar(timestamps, '$.start') AS starttime,
    json_extract_scalar(timestamps, '$.end') AS endtime,
    (
        cast(
            json_extract_scalar(timestamps, '$.end') AS DOUBLE
        ) - cast(
            json_extract_scalar(timestamps, '$.start') AS DOUBLE
        )
    ) AS duration,
    0 AS cliffduration,
    json_extract_scalar(amounts, '$.deposit') AS deposit,
    '0' AS protocolfee,
    json_extract_scalar(amounts, '$.brokerFee') AS brokerfee
FROM
    sablier_v2_2_multichain."SablierV2LockupTranched_evt_CreateLockupTranchedStream"
