from datetime import datetime, timezone
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport

from helpers import (
    add_quarter_argument,
    create_base_parser,
    get_last_quarter_months,
    months_to_quarter_label,
    parse_quarter_to_months,
    print_header,
    print_section_header,
    save_json_results,
)

# Subgraph endpoints for different products
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
    """Fetch extra user data from multiple subgraph endpoints."""
    parser = create_base_parser("Fetch extra user data from subgraph endpoints")
    add_quarter_argument(parser)
    args = parser.parse_args()

    print_header("🔗 SABLIER SUBGRAPH EXTRA USERS (AIRDROPS + LOCKUP)")

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

    # Calculate quarter timestamps (first day of first month to last day of last month)
    from helpers import parse_month

    # Get start of first month
    start_month_ts, _ = parse_month(months[0])
    # Get end of last month
    _, end_month_ts = parse_month(months[-1])

    start_date = datetime.fromtimestamp(start_month_ts, tz=timezone.utc)
    end_date = datetime.fromtimestamp(end_month_ts, tz=timezone.utc)

    print(f"📊 Fetching data for {quarter_label}")
    print(f"   Period: {start_date.strftime('%Y-%m-%d %H:%M:%S')} to {end_date.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"   Unix timestamps: {start_month_ts} to {end_month_ts}")
    print()

    all_extra_users = set()  # Use set for deduplication across all endpoints

    # Fetch data from Airdrops subgraph endpoints
    print_section_header("🎁 FETCHING FROM AIRDROPS SUBGRAPHS")
    for endpoint_key, endpoint_url in AIRDROPS_ENDPOINTS.items():
        print(f"🔍 Fetching from {endpoint_key.upper()}")
        print(f"🌐 Endpoint: {endpoint_url}")

        recipients = fetch_airdrops_actions_paginated(endpoint_key, endpoint_url, start_month_ts, end_month_ts)

        if recipients:
            unique_recipients = set(recipients)
            all_extra_users.update(unique_recipients)
            print(f"   ✅ Found {len(unique_recipients):,} unique claimRecipients for {endpoint_key}")
        else:
            print(f"   ⚠️  No recipients found for {endpoint_key}")

        print()

    # Fetch data from Lockup subgraph endpoints
    print_section_header("🔒 FETCHING FROM LOCKUP SUBGRAPHS")
    for endpoint_key, endpoint_url in LOCKUP_ENDPOINTS.items():
        print(f"🔍 Fetching from {endpoint_key.upper()}")
        print(f"🌐 Endpoint: {endpoint_url}")

        addresses = fetch_lockup_actions_paginated(endpoint_key, endpoint_url, start_month_ts, end_month_ts)

        if addresses:
            unique_addresses = set(addresses)
            all_extra_users.update(unique_addresses)
            print(f"   ✅ Found {len(unique_addresses):,} unique addresses for {endpoint_key}")
        else:
            print(f"   ⚠️  No addresses found for {endpoint_key}")

        print()

    if not all_extra_users:
        print("❌ No address data found from any endpoint")
        return

    # Convert to sorted list for consistent output
    all_extra_users_list = sorted(list(all_extra_users))
    total_unique_addresses = len(all_extra_users_list)

    print_section_header("📈 EXTRA USERS RESULTS")
    print(f"🎯 Total unique addresses across all endpoints: {total_unique_addresses:,}")
    print()

    # Save extra users results
    print_section_header("💾 SAVING EXTRA USERS RESULTS")

    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "total_unique_addresses": total_unique_addresses,
        "start_timestamp": start_month_ts,
        "end_timestamp": end_month_ts,
        "airdrops_endpoints": list(AIRDROPS_ENDPOINTS.keys()),
        "lockup_endpoints": list(LOCKUP_ENDPOINTS.keys()),
        "all_unique_addresses": all_extra_users_list,
    }

    save_json_results(
        output_data,
        "envio/users",
        f"extra-{quarter_label}.json",
        f"🎯 Total Unique Addresses: {total_unique_addresses:,}",
    )

    print()
    print("✅ Extra users complete! 🎉")


if __name__ == "__main__":
    main()
