from datetime import datetime, timezone
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport

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

# Subgraph endpoints for additional user data
AIRDROPS_ENDPOINTS = {
    "airdrops_form": "https://formapi.0xgraph.xyz/api/public/5961fb30-8fdc-45ad-9a35-555dd5e0dd56/subgraphs/sablier-airdrops-form/2.3_1.0.0/gn",
    "airdrops_chiliz": "https://api.studio.thegraph.com/query/112500/sablier-airdrops-chiliz/version/latest",
    "airdrops_sei": "https://api.studio.thegraph.com/query/112500/sablier-airdrops-sei/version/latest",
    "airdrops_lightlink": "https://graph.phoenix.lightlink.io/query/subgraphs/name/lightlink/sablier-airdrops-lightlink",
}

LOCKUP_ENDPOINTS = {
    "lockup_chiliz": "https://api.studio.thegraph.com/query/112500/sablier-lockup-chiliz/version/latest",
    "lockup_form": "https://formapi.0xgraph.xyz/api/public/5961fb30-8fdc-45ad-9a35-555dd5e0dd56/subgraphs/sablier-lockup-form/2.3_1.0.0/gn",
    "lockup_sei": "https://api.studio.thegraph.com/query/112500/sablier-lockup-sei/version/latest",
    "lockup_lightlink": "https://graph.phoenix.lightlink.io/query/subgraphs/name/lightlink/sablier-lockup-lightlink",
}


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


def create_subgraph_client(endpoint_url):
    """
    Create a GraphQL client for the specified subgraph endpoint.

    Args:
        endpoint_url (str): The subgraph endpoint URL

    Returns:
        Client: Configured GraphQL client
    """
    transport = RequestsHTTPTransport(url=endpoint_url)
    return Client(transport=transport)


def fetch_airdrops_actions_paginated(endpoint_key, endpoint_url, start_timestamp, end_timestamp):
    """
    Fetch all airdrops actions from a subgraph using GraphQL with pagination.

    Args:
        endpoint_key (str): Key for the endpoint
        endpoint_url (str): The subgraph endpoint URL
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        list: List of unique claimRecipient addresses
    """
    client = create_subgraph_client(endpoint_url)

    # GraphQL query to fetch airdrops actions with timestamp filtering
    query = gql("""
        query GetActions($first: Int!, $skip: Int!, $startTimestamp: BigInt!, $endTimestamp: BigInt!) {
            actions(first: $first, skip: $skip, where: { timestamp_gt: $startTimestamp, timestamp_lt: $endTimestamp }) {
                id
                claimRecipient
            }
        }
    """)

    all_recipients = []
    first = 1000  # Fetch 1000 records at a time
    skip = 0

    while True:
        variables = {
            "first": first,
            "skip": skip,
            "startTimestamp": str(start_timestamp),
            "endTimestamp": str(end_timestamp),
        }

        try:
            result = client.execute(query, variable_values=variables)
            result_data = {"data": result}
        except Exception as e:
            print(f"Error executing query for endpoint {endpoint_key}: {e}")
            break

        if not result_data or "data" not in result_data or "actions" not in result_data["data"]:
            print(f"   ❌ No data found for {endpoint_key}")
            break

        actions = result_data["data"]["actions"]

        if not actions:
            # No more results
            break

        # Extract claimRecipient addresses
        recipients = [action["claimRecipient"] for action in actions if action.get("claimRecipient")]
        all_recipients.extend(recipients)

        print(f"   📥 Fetched {len(recipients)} airdrops actions from {endpoint_key} (skip: {skip})")

        # If we got fewer results than the limit, we've reached the end
        if len(actions) < first:
            break

        # Move to next page
        skip += first

    return all_recipients


def fetch_lockup_actions_paginated(endpoint_key, endpoint_url, start_timestamp, end_timestamp):
    """
    Fetch all lockup actions from a subgraph using GraphQL with pagination.

    Args:
        endpoint_key (str): Key for the endpoint
        endpoint_url (str): The subgraph endpoint URL
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        list: List of unique addresses (addressA and addressB)
    """
    client = create_subgraph_client(endpoint_url)

    # GraphQL query to fetch lockup actions with timestamp filtering
    query = gql("""
        query GetActions($first: Int!, $skip: Int!, $startTimestamp: BigInt!, $endTimestamp: BigInt!) {
            actions(first: $first, skip: $skip, where: { timestamp_gt: $startTimestamp, timestamp_lt: $endTimestamp }) {
                id
                addressA
                addressB
            }
        }
    """)

    all_addresses = []
    first = 1000  # Fetch 1000 records at a time
    skip = 0

    while True:
        variables = {
            "first": first,
            "skip": skip,
            "startTimestamp": str(start_timestamp),
            "endTimestamp": str(end_timestamp),
        }

        try:
            result = client.execute(query, variable_values=variables)
            result_data = {"data": result}
        except Exception as e:
            print(f"Error executing query for endpoint {endpoint_key}: {e}")
            break

        if not result_data or "data" not in result_data or "actions" not in result_data["data"]:
            print(f"   ❌ No data found for {endpoint_key}")
            break

        actions = result_data["data"]["actions"]

        if not actions:
            # No more results
            break

        # Extract addressA and addressB
        for action in actions:
            if action.get("addressA"):
                all_addresses.append(action["addressA"])
            if action.get("addressB"):
                all_addresses.append(action["addressB"])

        print(f"   📥 Fetched {len(actions)} lockup actions from {endpoint_key} (skip: {skip})")

        # If we got fewer results than the limit, we've reached the end
        if len(actions) < first:
            break

        # Move to next page
        skip += first

    return all_addresses


def main():
    """Fetch and analyze Quarterly Active Users (can specify quarter or use last 3 months)."""
    parser = create_base_parser("Fetch Quarterly MAUs from Envio and Subgraphs")
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

    # Fetch subgraph data for each month and incorporate into MAUs
    print_section_header("🔗 FETCHING ADDITIONAL USERS FROM SUBGRAPHS")
    
    # Update each month's results with subgraph data
    for month in months:
        print_section_header(f"📊 PROCESSING SUBGRAPH DATA FOR: {month}")
        
        try:
            start_timestamp, end_timestamp = parse_month(month)
        except ValueError as e:
            print(f"❌ Error parsing month {month}: {e}")
            continue

        month_subgraph_addresses = set()

        # Fetch data from Airdrops subgraph endpoints for this month
        print("🎁 Airdrops subgraphs:")
        for endpoint_key, endpoint_url in AIRDROPS_ENDPOINTS.items():
            print(f"   🔍 Fetching from {endpoint_key}")
            recipients = fetch_airdrops_actions_paginated(endpoint_key, endpoint_url, start_timestamp, end_timestamp)
            
            if recipients:
                unique_recipients = set(recipients)
                month_subgraph_addresses.update(unique_recipients)
                print(f"      ✅ Found {len(unique_recipients):,} unique claimRecipients")
            else:
                print("      ⚠️  No recipients found")

        # Fetch data from Lockup subgraph endpoints for this month
        print("🔒 Lockup subgraphs:")
        for endpoint_key, endpoint_url in LOCKUP_ENDPOINTS.items():
            print(f"   🔍 Fetching from {endpoint_key}")
            addresses = fetch_lockup_actions_paginated(endpoint_key, endpoint_url, start_timestamp, end_timestamp)
            
            if addresses:
                unique_addresses = set(addresses)
                month_subgraph_addresses.update(unique_addresses)
                print(f"      ✅ Found {len(unique_addresses):,} unique addresses")
            else:
                print("      ⚠️  No addresses found")

        # Get existing Envio addresses for this month
        month_envio_addresses = set(quarterly_results[month]["addresses"])
        
        # Combine Envio and subgraph addresses for this month
        month_combined_addresses = month_envio_addresses.union(month_subgraph_addresses)
        
        # Update the monthly results with combined data
        quarterly_results[month]["envio_users"] = len(month_envio_addresses)
        quarterly_results[month]["subgraph_users"] = len(month_subgraph_addresses)
        quarterly_results[month]["combined_unique_users"] = len(month_combined_addresses)
        quarterly_results[month]["additional_from_subgraphs"] = len(month_subgraph_addresses - month_envio_addresses)
        quarterly_results[month]["all_combined_addresses"] = sorted(list(month_combined_addresses))
        
        # Update the total_unique_users to reflect combined data
        quarterly_results[month]["total_unique_users"] = len(month_combined_addresses)
        
        print(f"📊 {month} - Envio: {len(month_envio_addresses):,}, Subgraph: {len(month_subgraph_addresses):,}, Combined: {len(month_combined_addresses):,}")
        print()

    # Recalculate quarterly totals with combined data
    all_quarterly_addresses = set()
    for month_data in quarterly_results.values():
        all_quarterly_addresses.update(month_data["all_combined_addresses"])

    all_quarterly_addresses_list = sorted(list(all_quarterly_addresses))
    total_quarterly_unique = len(all_quarterly_addresses_list)

    print_section_header("📈 QUARTERLY RESULTS SUMMARY")

    # Show breakdown of results
    for month, data in quarterly_results.items():
        print(f"👥 {month}: {data['total_unique_users']:,} unique MAUs (Envio: {data['envio_users']:,}, Subgraph: {data['subgraph_users']:,})")

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
