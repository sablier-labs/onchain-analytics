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


def fetch_transactions_paginated(endpoint_key, start_timestamp, end_timestamp):
    """
    Fetch all unique transaction hashes from Envio using Hasura GraphQL with pagination.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        list: List of unique transaction hashes
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch UserTransaction entities with timestamp filtering
    query = gql("""
        query GetQuarterlyTransactions($limit: Int!, $offset: Int!, $startTimestamp: numeric!, $endTimestamp: numeric!, $excludedChainIds: [numeric!]!) {
            UserTransaction(
                distinct_on: [hash]
                limit: $limit
                offset: $offset
                where: { user: {chainId: {_nin: $excludedChainIds}}, timestamp: {_gte: $startTimestamp, _lte: $endTimestamp}}
            ) {
                hash
            }
        }
    """)

    all_hashes = []
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

        if not result or "data" not in result or "UserTransaction" not in result["data"]:
            print(f"   ❌ No data found for {endpoint_key}")
            break

        transactions = result["data"]["UserTransaction"]

        if not transactions:
            # No more results
            break

        # Extract hashes
        hashes = [tx["hash"] for tx in transactions if tx.get("hash")]
        all_hashes.extend(hashes)

        print(f"   📥 Fetched {len(hashes)} transactions from {endpoint_key} (offset: {offset})")

        # If we got fewer results than the limit, we've reached the end
        if len(transactions) < limit:
            break

        # Move to next page
        offset += limit

    return all_hashes


def main():
    """Fetch and analyze Quarterly Transaction counts (can specify quarter or use last 3 months)."""
    parser = create_base_parser("Fetch Quarterly Transactions from Envio")
    add_quarter_argument(parser)
    args = parser.parse_args()

    print_header("📊 SABLIER QUARTERLY TRANSACTIONS ANALYTICS")

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
    all_quarterly_hashes = set()  # Use set for deduplication across quarter

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
        print(f"\n🔄 Fetching Transactions from Envio for {month}...")
        print()

        month_hashes = set()  # Use set for deduplication within month

        # Fetch transactions from all protocols
        for protocol in PROTOCOLS:
            print(f"🔍 Fetching transactions from {protocol}...")
            hashes = fetch_transactions_paginated(protocol, start_timestamp, end_timestamp)

            if hashes:
                protocol_unique = set(hashes)
                month_hashes.update(protocol_unique)
                print(f"   ✅ Found {len(protocol_unique):,} unique transactions for {protocol}")
            else:
                print(f"   ⚠️  No transactions found for {protocol}")

        if not month_hashes:
            print(f"❌ No transaction data found for {month}")
            quarterly_results[month] = {"total_transactions": 0, "hashes": []}
            continue

        # Store monthly results
        monthly_total = len(month_hashes)
        quarterly_results[month] = {
            "total_transactions": monthly_total,
            "hashes": sorted(list(month_hashes)),  # Convert to sorted list for JSON
        }

        # Add to quarterly total
        all_quarterly_hashes.update(month_hashes)

        print(f"📊 {month} Total: {monthly_total:,} transactions")
        print()

    if not quarterly_results:
        print("❌ No transaction data found for any month")
        return

    # Convert quarterly hashes to sorted list
    all_quarterly_hashes_list = sorted(list(all_quarterly_hashes))
    total_quarterly_unique = len(all_quarterly_hashes_list)

    # Calculate quarterly average
    quarterly_average = sum(d["total_transactions"] for d in quarterly_results.values()) / len(quarterly_results)

    print_section_header("📈 QUARTERLY RESULTS SUMMARY")

    for month, data in quarterly_results.items():
        print(f"📊 {month}: {data['total_transactions']:,} unique transactions")

    print()
    print(f"🎯 Total unique transactions across quarter: {total_quarterly_unique:,} transactions")
    print(f"📊 Average transactions per month: {quarterly_average:,.0f} transactions")
    print()

    # Save detailed results
    print_section_header("💾 SAVING RESULTS")

    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "total_unique_quarterly_transactions": total_quarterly_unique,
        "average_monthly_transactions": round(quarterly_average),
        "monthly_results": quarterly_results,
        "all_unique_hashes": all_quarterly_hashes_list,
    }

    save_json_results(
        output_data,
        "envio/transactions",
        f"{quarter_label}.json",
        f"📊 Total Unique Quarterly Transactions: {total_quarterly_unique:,}",
    )

    print()
    print("✅ Quarterly analysis complete! 🎉")


if __name__ == "__main__":
    main()
