# https://envio.dev/app/sablier-labs/lockup-envio
ENDPOINTS = {
    "airdrops": "https://indexer.hyperindex.xyz/5dd79b6/v1/graphql",
    "flow": "https://indexer.hyperindex.xyz/523ac61/v1/graphql",
    "lockup": "https://indexer.hyperindex.xyz/9074833/v1/graphql",
}

# https://github.com/sablier-labs/sdk/blob/15a5cc9/src/chains/data.ts
CHAINS = [
    {"id": 1, "name": "Ethereum Mainnet"},
    {"id": 10, "name": "Optimism"},
    {"id": 50, "name": "XDC"},
    {"id": 56, "name": "BNB Smart Chain"},
    {"id": 100, "name": "Gnosis"},
    {"id": 130, "name": "Unichain"},
    {"id": 137, "name": "Polygon"},
    {"id": 324, "name": "zkSync"},
    {"id": 478, "name": "Form"},
    {"id": 1329, "name": "Sei"},
    {"id": 1890, "name": "Lightlink"},
    {"id": 2741, "name": "Abstract"},
    {"id": 2818, "name": "Morph"},
    {"id": 4689, "name": "IoTeX"},
    {"id": 5330, "name": "Superseed"},
    {"id": 5845, "name": "Tangle"},
    {"id": 8453, "name": "Base"},
    {"id": 34443, "name": "Mode"},
    {"id": 42161, "name": "Arbitrum"},
    {"id": 43114, "name": "Avalanche"},
    {"id": 50104, "name": "Sophon"},
    {"id": 59144, "name": "Linea"},
    {"id": 81457, "name": "Blast"},
    {"id": 80094, "name": "Berachain"},
    {"id": 88888, "name": "Chiliz"},
    {"id": 534352, "name": "Scroll"},
]

# Derived lists for backward compatibility
CHAIN_IDS = [chain["id"] for chain in CHAINS]
CHAIN_NAMES = {chain["id"]: chain["name"] for chain in CHAINS}

EXCLUDED_CHAIN_IDS = [
    88888,  # Chiliz
    1890,  # Lightlink
    478,  # Form
    1329,  # Sei
    84532,  # Base Sepolia
    421614,  # Arbitrum Sepolia
    11155111,  # Ethereum Sepolia
    11155420,  # Optimism Sepolia
]

PROTOCOLS = ["airdrops", "flow", "lockup"]
