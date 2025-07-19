"""
TODO: add price data source
"""

from gql import gql

from constants import CHAINS, PROTOCOLS
from helpers import (
    add_limit_argument,
    add_quarter_argument,
    create_base_parser,
    create_graphql_client,
    execute_graphql_query,
    get_most_recent_complete_quarter,
    handle_period_parsing,
    parse_quarter,
    print_header,
    print_section_header,
    save_json_results,
)


def fetch_revenues(endpoint_key, limit, chain_id, start_timestamp, end_timestamp):
    """
    Fetch Revenue entities from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        limit (int): Number of records to fetch (default: 1000)
        chain_id (int): Filter by chain ID
        start_timestamp (str): Start timestamp in ISO format
        end_timestamp (str): End timestamp in ISO format

    Returns:
        dict: GraphQL response containing Revenue entities
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch Revenue entities with date filtering
    query = gql("""
        query GetRevenues(
            $limit: Int!,
            $chainId: numeric!,
            $startTimestamp: timestamptz!,
            $endTimestamp: timestamptz!
        ) {
            Revenue(limit: $limit, where: {
                chainId: { _eq: $chainId },
                dateTimestamp: { _gte: $startTimestamp, _lte: $endTimestamp }
            }) {
                id
                amount
                chainId
                currency
                date
                dateTimestamp
            }
        }
    """)

    variables = {
        "limit": limit,
        "chainId": chain_id,
        "startTimestamp": start_timestamp,
        "endTimestamp": end_timestamp,
    }

    return execute_graphql_query(client, query, variables, f"{endpoint_key}-chain-{chain_id}")


def aggregate_revenues_by_currency(all_revenues):
    """
    Aggregate revenues by currency across all chains.

    Args:
        all_revenues (list): List of revenue records from all chains

    Returns:
        dict: Aggregated revenues by currency
    """
    aggregated = {}

    for revenue in all_revenues:
        currency = revenue["currency"]
        amount = float(revenue["amount"])

        if currency not in aggregated:
            aggregated[currency] = {"total_amount": 0.0, "currency": currency}

        aggregated[currency]["total_amount"] += amount

    return aggregated


def process_protocol_revenues(protocol, limit, start_timestamp, end_timestamp):
    """
    Process revenues for a single protocol across all chains.

    Args:
        protocol (str): Protocol name
        limit (int): Record limit per chain
        start_timestamp (str): Start timestamp
        end_timestamp (str): End timestamp

    Returns:
        list: All revenue records for the protocol
    """
    protocol_revenues = []

    for chain in CHAINS:
        chain_id = chain["id"]
        chain_name = chain["name"]
        print(f"   ⛓️  Fetching data for {chain_name} (ID: {chain_id})...")

        result = fetch_revenues(
            protocol,
            limit=limit,
            chain_id=chain_id,
            start_timestamp=start_timestamp,
            end_timestamp=end_timestamp,
        )

        if not result:
            print(f"      ❌ Failed to fetch revenue data for {chain_name}")
            print("      🛑 Stopping execution due to error")
            return None

        if "errors" in result:
            print(f"      ❌ GraphQL errors for {chain_name}: {result['errors']}")
            print("      🛑 Stopping execution due to error")
            return None

        if "data" not in result or "Revenue" not in result["data"]:
            print(f"      ⚠️  No Revenue data found for {chain_name}")
            continue

        revenues = result["data"]["Revenue"]
        print(f"      ✅ Found {len(revenues):,} revenue records for {chain_name}")
        protocol_revenues.extend(revenues)

    return protocol_revenues


def main():
    """Fetch and print Revenue entities."""
    parser = create_base_parser("Fetch Revenue entities from Envio")
    add_quarter_argument(parser)
    add_limit_argument(parser, default=1000)
    args = parser.parse_args()

    print_header("🚀 SABLIER REVENUE ANALYTICS")

    # Handle period parsing
    result = handle_period_parsing("quarter", args.quarter, parse_quarter, get_most_recent_complete_quarter)
    if result[0] is None:
        return

    quarter, timestamps = result
    start_timestamp, end_timestamp = timestamps

    from datetime import datetime

    start_date = datetime.fromisoformat(start_timestamp.replace("Z", "+00:00"))
    end_date = datetime.fromisoformat(end_timestamp.replace("Z", "+00:00"))

    print(f"📊 Fetching revenues for {quarter}")
    print(f"   Period: {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")
    print()

    print("\n🔄 Fetching Revenue entities from Envio for all protocols...")
    print(f"📊 Limit per chain: {args.limit:,}")
    print()

    all_protocols_data = {}
    total_revenues = []

    for protocol in PROTOCOLS:
        print(f"🔗 Processing protocol: {protocol}")
        from constants import ENDPOINTS

        print(f"🌐 Endpoint: {ENDPOINTS[protocol]}")

        protocol_revenues = process_protocol_revenues(protocol, args.limit, start_timestamp, end_timestamp)

        if protocol_revenues is None:
            return

        # Aggregate by currency for this protocol
        protocol_aggregated = aggregate_revenues_by_currency(protocol_revenues)
        all_protocols_data[protocol] = {"currencies": protocol_aggregated}
        total_revenues.extend(protocol_revenues)

        print(f"   📊 Protocol {protocol} total: {len(protocol_revenues):,} records")
        print()

    if not total_revenues:
        print("❌ No revenue data found for any protocol")
        return

    print(f"🎯 Total revenue records across all protocols: {len(total_revenues):,}")
    print()

    # Aggregate by currency across all protocols
    aggregated = aggregate_revenues_by_currency(total_revenues)

    print_section_header("📈 REVENUE AGGREGATION RESULTS")
    print(f"🕐 Quarter: {quarter}")
    print(f"💰 Total Currencies: {len(aggregated)}")
    print()

    for currency, data in sorted(aggregated.items()):
        print(f"💱 Currency: {currency}")
        print(f"   💵 Total Amount: {data['total_amount']:.6f}")
        print()

    # Save results
    print_section_header("💾 SAVING RESULTS")

    output_data = {
        "quarter": quarter,
        "total_currencies": len(aggregated),
        "currencies": dict(sorted(aggregated.items())),
    }

    save_json_results(output_data, "envio/revenues", f"{quarter}.json", f"🏦 Total currencies: {len(aggregated)}")

    print()
    print("✅ Analysis complete! 🎉")


if __name__ == "__main__":
    main()
