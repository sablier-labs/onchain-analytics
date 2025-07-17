import argparse
import json
import os
from datetime import datetime, timezone
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport
from constants import ENDPOINTS, CHAINS
from helpers import parse_quarter, get_most_recent_complete_quarter


def fetch_revenues(endpoint_key, limit, chain_id, start_timestamp, end_timestamp):
    """
    Fetch Revenue entities from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        limit (int): Number of records to fetch (default: 1000)
        chain_id (int): Filter by chain ID
        start_timestamp (int): Start timestamp in seconds
        end_timestamp (int): End timestamp in seconds

    Returns:
        dict: GraphQL response containing Revenue entities
    """
    endpoint = ENDPOINTS[endpoint_key]

    # Set up GraphQL client
    transport = RequestsHTTPTransport(url=endpoint)
    client = Client(transport=transport)

    # GraphQL query to fetch Revenue entities with date filtering
    query = gql("""
        query FetchRevenues(
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

    try:
        variables = {
            "limit": limit,
            "chainId": chain_id,
            "startTimestamp": start_timestamp,
            "endTimestamp": end_timestamp,
        }
        result = client.execute(query, variable_values=variables)
        return {"data": result}
    except Exception as e:
        print(f"Error fetching revenues for chain {chain_id}: {e}")
        return None


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
            aggregated[currency] = {"total_amount": 0.0, "record_count": 0, "currency": currency}

        aggregated[currency]["total_amount"] += amount
        aggregated[currency]["record_count"] += 1

    return aggregated


def save_results_to_json(aggregated_data, quarter, all_revenues, protocols_data):
    """
    Save aggregated results to JSON file.

    Args:
        aggregated_data (dict): Aggregated revenue data by currency
        quarter (str): Quarter string (e.g., '2025-q2')
        all_revenues (list): All revenue records
        protocols_data (dict): Protocol-specific revenue data
    """
    # Create output directory if it doesn't exist
    output_dir = "envio/revenues"
    os.makedirs(output_dir, exist_ok=True)

    # Prepare output data
    output_data = {
        "quarter": quarter,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_records": len(all_revenues),
        "total_currencies": len(aggregated_data),
        "currencies": aggregated_data,
    }

    # Save to JSON file
    filename = f"{output_dir}/{quarter}.json"
    with open(filename, "w") as f:
        json.dump(output_data, f, indent=2, default=str)

    print(f"📁 Results saved to: {filename}")
    print(f"📊 Total records: {len(all_revenues):,}")
    print(f"🏦 Total currencies: {len(aggregated_data)}")
    return filename


def main():
    """Fetch and print Revenue entities."""
    parser = argparse.ArgumentParser(description="Fetch Revenue entities from Envio")
    parser.add_argument(
        "--quarter",
        type=str,
        help="Quarter in format 'YYYY-qN' (e.g., '2025-q2'). If not specified, uses most recent complete quarter.",
    )
    parser.add_argument("--limit", type=int, default=1000, help="Number of records to fetch per chain (default: 1000)")

    args = parser.parse_args()

    print("\n" + "=" * 80)
    print("🚀 SABLIER REVENUE ANALYTICS")
    print("=" * 80)

    # Determine quarter to use
    if args.quarter:
        quarter = args.quarter
        print(f"📅 Quarter specified: {quarter}")
    else:
        quarter = get_most_recent_complete_quarter()
        print(f"📅 Using most recent complete quarter: {quarter}")

    print()

    try:
        start_timestamp, end_timestamp = parse_quarter(quarter)
        start_date = datetime.fromisoformat(start_timestamp.replace("Z", "+00:00"))
        end_date = datetime.fromisoformat(end_timestamp.replace("Z", "+00:00"))
        print(f"📊 Fetching revenues for {quarter}")
        print(f"   Period: {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")
    except ValueError as e:
        print(f"❌ Error parsing quarter: {e}")
        return

    print("\n🔄 Fetching Revenue entities from Envio for all protocols...")
    print(f"📊 Limit per chain: {args.limit:,}")
    print()

    all_protocols_data = {}
    total_revenues = []

    # Fetch revenues from all protocols
    protocols = ["airdrops", "flow", "lockup"]

    for protocol in protocols:
        print(f"🔗 Processing protocol: {protocol}")
        print(f"🌐 Endpoint: {ENDPOINTS[protocol]}")

        protocol_revenues = []

        for chain in CHAINS:
            chain_id = chain["id"]
            chain_name = chain["name"]
            print(f"   ⛓️  Fetching data for {chain_name} (ID: {chain_id})...")

            result = fetch_revenues(
                protocol,
                limit=args.limit,
                chain_id=chain_id,
                start_timestamp=start_timestamp,
                end_timestamp=end_timestamp,
            )

            if not result:
                print(f"      ❌ Failed to fetch revenue data for {chain_name}")
                print("      🛑 Stopping execution due to error")
                return

            if "errors" in result:
                print(f"      ❌ GraphQL errors for {chain_name}: {result['errors']}")
                print("      🛑 Stopping execution due to error")
                return

            if "data" not in result or "Revenue" not in result["data"]:
                print(f"      ⚠️  No Revenue data found for {chain_name}")
                continue

            revenues = result["data"]["Revenue"]
            print(f"      ✅ Found {len(revenues):,} revenue records for {chain_name}")
            protocol_revenues.extend(revenues)

        # Aggregate by currency for this protocol
        protocol_aggregated = aggregate_revenues_by_currency(protocol_revenues)
        all_protocols_data[protocol] = {"total_records": len(protocol_revenues), "currencies": protocol_aggregated}
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

    print("📈 REVENUE AGGREGATION RESULTS")
    print("=" * 80)
    print(f"🕐 Quarter: {quarter}")
    print(f"💰 Total Currencies: {len(aggregated)}")
    print()

    for currency, data in sorted(aggregated.items()):
        print(f"💱 Currency: {currency}")
        print(f"   💵 Total Amount: {data['total_amount']:.6f}")
        print(f"   📊 Record Count: {data['record_count']:,}")
        print()

    # Save results to JSON file
    print("💾 SAVING RESULTS")
    print("=" * 80)
    save_results_to_json(aggregated, quarter, total_revenues, all_protocols_data)
    print()
    print("✅ Analysis complete! 🎉")


if __name__ == "__main__":
    main()
