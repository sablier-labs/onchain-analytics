from datetime import datetime, timezone
from gql import gql

from constants import PROTOCOLS, EXCLUDED_CHAIN_IDS
from helpers import (
    add_quarter_argument,
    create_base_parser,
    create_graphql_client,
    execute_graphql_query,
    get_last_quarter_months,
    months_to_quarter_label,
    parse_month,
    parse_quarter_to_months,
    print_header,
    print_period_info,
    print_section_header,
    save_json_results,
)


def fetch_users_paginated(endpoint_key, start_timestamp, end_timestamp):
    """
    Fetch all unique active users from Envio using Hasura GraphQL with pagination.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        list: List of unique user addresses
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch User entities with transaction timestamp filtering
    query = gql("""
        query GetQuarterlyActiveUsers($limit: Int!, $offset: Int!, $startTimestamp: numeric!, $endTimestamp: numeric!, $excludedChainIds: [numeric!]!) {
            User(
                distinct_on: [address]
                limit: $limit
                offset: $offset
                where: {chainId: {_nin: $excludedChainIds}, transactions: {timestamp: {_gte: $startTimestamp, _lte: $endTimestamp}}}
            ) {
                address
            }
        }
    """)

    all_addresses = []
    limit = 1000  # Fetch 1000 records at a time
    offset = 0

    while True:
        variables = {
            "limit": limit,
            "offset": offset,
            "startTimestamp": start_timestamp,
            "endTimestamp": end_timestamp,
            "excludedChainIds": EXCLUDED_CHAIN_IDS,
        }

        result = execute_graphql_query(client, query, variables, endpoint_key)

        if not result or "data" not in result or "User" not in result["data"]:
            print(f"   ❌ No data found for {endpoint_key}")
            break

        users = result["data"]["User"]

        if not users:
            # No more results
            break

        # Extract addresses
        addresses = [user["address"] for user in users if user.get("address")]
        all_addresses.extend(addresses)

        print(f"   📥 Fetched {len(addresses)} users from {endpoint_key} (offset: {offset})")

        # If we got fewer results than the limit, we've reached the end
        if len(users) < limit:
            break

        # Move to next page
        offset += limit

    return all_addresses


def main():
    """Fetch and analyze Quarterly Active Users (can specify quarter or use last 3 months)."""
    parser = create_base_parser("Fetch Quarterly MAUs from Envio")
    add_quarter_argument(parser)
    args = parser.parse_args()

    print_header("👥 SABLIER QUARTERLY MAUs ANALYTICS")

    # Determine which months to analyze
    if args.quarter:
        quarter_str = args.quarter
        print(f"📅 Quarter specified: {quarter_str}")

        try:
            months, quarter_label = parse_quarter_to_months(quarter_str)
        except ValueError as e:
            print(f"❌ Error parsing quarter: {e}")
            print("   Expected format: YYYY-qN (e.g., 2025-q1)")
            return
    else:
        # Get last 3 complete months
        months = get_last_quarter_months()
        quarter_label = months_to_quarter_label(months)
        print(f"📅 Using most recent complete quarter: {quarter_label}")

    print(f"📅 Analyzing months: {', '.join(months)}")
    print()

    quarterly_results = {}
    all_quarterly_addresses = set()  # Use set for deduplication

    # Process each month
    for month in months:
        print_section_header(f"📊 PROCESSING MONTH: {month}")

        try:
            start_timestamp, end_timestamp = parse_month(month)
        except ValueError as e:
            print(f"❌ Error parsing month {month}: {e}")
            continue

        start_date = datetime.fromtimestamp(start_timestamp, tz=timezone.utc)
        end_date = datetime.fromtimestamp(end_timestamp, tz=timezone.utc)

        print_period_info("Month", month, start_date, end_date, start_timestamp, end_timestamp)
        print(f"\n🔄 Fetching MAUs from Envio for {month}...")
        print()

        month_addresses = set()  # Use set for deduplication within month

        # Fetch users from all protocols
        for protocol in PROTOCOLS:
            print(f"🔍 Fetching users from {protocol}...")
            addresses = fetch_users_paginated(protocol, start_timestamp, end_timestamp)

            if addresses:
                protocol_unique = set(addresses)
                month_addresses.update(protocol_unique)
                print(f"   ✅ Found {len(protocol_unique):,} unique addresses for {protocol}")
            else:
                print(f"   ⚠️  No users found for {protocol}")

        if not month_addresses:
            print(f"❌ No user data found for {month}")
            quarterly_results[month] = {"total_unique_users": 0, "addresses": []}
            continue

        # Store monthly results
        monthly_total = len(month_addresses)
        quarterly_results[month] = {
            "total_unique_users": monthly_total,
            "addresses": sorted(list(month_addresses)),  # Convert to sorted list for JSON
        }

        # Add to quarterly total
        all_quarterly_addresses.update(month_addresses)

        print(f"📊 {month} Total: {monthly_total:,} unique MAUs")
        print()

    if not quarterly_results:
        print("❌ No user data found for any month")
        return

    # Convert quarterly addresses to sorted list
    all_quarterly_addresses_list = sorted(list(all_quarterly_addresses))
    total_quarterly_unique = len(all_quarterly_addresses_list)

    print_section_header("📈 QUARTERLY RESULTS SUMMARY")

    for month, data in quarterly_results.items():
        print(f"👥 {month}: {data['total_unique_users']:,} unique MAUs")

    print()
    print(f"📊 Total unique users across quarter: {total_quarterly_unique:,} MAUs")
    print(
        f"📊 Average MAUs per month: {sum(d['total_unique_users'] for d in quarterly_results.values()) / len(quarterly_results):,.0f} MAUs"
    )
    print()

    # Save detailed results
    print_section_header("💾 SAVING RESULTS")

    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "total_unique_quarterly_users": total_quarterly_unique,
        "average_monthly_users": round(
            sum(d["total_unique_users"] for d in quarterly_results.values()) / len(quarterly_results)
        ),
        "monthly_results": quarterly_results,
        "all_unique_addresses": all_quarterly_addresses_list,
    }

    save_json_results(
        output_data,
        "envio/users",
        f"{quarter_label}.json",
        f"👥 Total Unique Quarterly Users: {total_quarterly_unique:,}",
    )

    print()
    print("✅ Quarterly analysis complete! 🎉")


if __name__ == "__main__":
    main()
