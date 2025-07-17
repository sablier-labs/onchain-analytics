# https://envio.dev/app/sablier-labs/lockup-envio
ENDPOINTS = {
    "airdrops": "https://indexer.hyperindex.xyz/85e925b/v1/graphql",
    "flow": "https://indexer.hyperindex.xyz/79728b1/v1/graphql",
    "lockup": "https://indexer.hyperindex.xyz/c2cf208/v1/graphql",
}

# https://github.com/sablier-labs/sdk/blob/15a5cc9/src/chains/data.ts
CHAINS = [
    {"id": 1, "name": "Ethereum Mainnet"},
    {"id": 10, "name": "Optimism"},
    {"id": 56, "name": "BNB Smart Chain"},
    {"id": 100, "name": "Gnosis"},
    {"id": 137, "name": "Polygon"},
    # {"id": 1329, "name": "Sei"},
    # {"id": 1890, "name": "Lightlink Phoenix"},
    {"id": 2020, "name": "Ronin"},
    # {"id": 4689, "name": "IoTeX"},
    # {"id": 478, "name": "Form"},
    {"id": 5330, "name": "Superseed"},
    {"id": 8453, "name": "Base"},
    {"id": 34443, "name": "Mode"},
    {"id": 42161, "name": "Arbitrum"},
    {"id": 43114, "name": "Avalanche"},
    {"id": 59144, "name": "Linea"},
    {"id": 81457, "name": "Blast"},
    {"id": 88888, "name": "Chiliz"},
    {"id": 167000, "name": "Taiko"},
    {"id": 534352, "name": "Scroll"},
]

# Derived lists for backward compatibility
CHAIN_IDS = [chain["id"] for chain in CHAINS]
CHAIN_NAMES = {chain["id"]: chain["name"] for chain in CHAINS}
