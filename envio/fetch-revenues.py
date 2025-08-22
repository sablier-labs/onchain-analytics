"""
Fetch revenue data from Envio analytics indexer using GraphQL query.
"""

import os
from gql import gql

from helpers import (
    add_quarter_argument,
    create_base_parser,
    create_graphql_client,
    execute_graphql_query,
    format_amount,
    get_most_recent_complete_quarter,
    handle_period_parsing,
    parse_quarter,
    print_header,
    print_section_header,
)


def load_graphql_query(query_type):
    """Load GraphQL query from file based on query type."""
    if query_type == "total":
        query_file = os.path.join(os.path.dirname(__file__), "queries", "get-total-revenues.graphql")
    else:  # quarter
        query_file = os.path.join(os.path.dirname(__file__), "queries", "get-quarter-revenues.graphql")

    with open(query_file, "r") as f:
        return gql(f.read())


def main():
    """Fetch and print Revenue entities."""
    parser = create_base_parser("Fetch Revenue entities from Envio Analytics")
    add_quarter_argument(parser)
    parser.add_argument(
        "--currency",
        type=str,
        required=True,
        help="Currency to query (e.g., 'ETH', 'USDC')",
    )
    parser.add_argument(
        "--total",
        action="store_true",
        help="Fetch total revenues (all-time). If specified, quarter argument is ignored.",
    )
    args = parser.parse_args()

    print_header("💰 SABLIER REVENUE ANALYTICS")

    print(f"💱 Currency: {args.currency}")

    # Create GraphQL client for analytics endpoint
    client = create_graphql_client("analytics")

    if args.total:
        # Total revenues mode
        print("📊 Mode: Total (All-time)")
        print()

        query = load_graphql_query("total")
        variables = {"currency": args.currency}

    else:
        # Quarter revenues mode
        result = handle_period_parsing("quarter", args.quarter, parse_quarter, get_most_recent_complete_quarter)
        if result[0] is None:
            return

        quarter, timestamps = result
        start_timestamp, end_timestamp = timestamps

        # Format timestamps to display just the dates
        start_date = start_timestamp.split("T")[0]
        end_date = end_timestamp.split("T")[0]

        print("📊 Mode: Quarter")
        print(f"📅 Quarter: {quarter}")
        print(f"⏰ Period: {start_date} to {end_date}")
        print()

        query = load_graphql_query("quarter")
        variables = {
            "currency": args.currency,
            "from": start_timestamp,
            "until": end_timestamp,
        }

    print_section_header("🔍 FETCHING REVENUE DATA")
    result = execute_graphql_query(client, query, variables, "analytics")

    if not result:
        print("❌ Failed to fetch revenue data")
        return

    if "errors" in result:
        print(f"❌ GraphQL errors: {result['errors']}")
        return

    data = result["data"]

    # Display results
    print_section_header("📊 REVENUE RESULTS")

    if args.total:
        # Display total results
        if "Total" in data and data["Total"]["aggregate"]["sum"]:
            total = data["Total"]["aggregate"]["sum"]
            print("🏦 Total (All Time):")
            print(f"   💰 Amount {args.currency}: {format_amount(total['amount'])}")
            print(f"   💷 Value GBP: {format_amount(total['valueGBP'])}")
            print(f"   💵 Value USD: {format_amount(total['valueUSD'])}")
        else:
            print(f"⚠️  No total revenue data found for {args.currency}")
    else:
        # Display quarter results
        if "Quarter" in data and data["Quarter"]["aggregate"]["sum"]:
            quarter_data = data["Quarter"]["aggregate"]["sum"]
            print(f"📅 Quarter {quarter}:")
            print(f"   💰 Amount {args.currency}: {format_amount(quarter_data['amount'])}")
            print(f"   💷 Value GBP: {format_amount(quarter_data['valueGBP'])}")
            print(f"   💵 Value USD: {format_amount(quarter_data['valueUSD'])}")
        else:
            print(f"⚠️  No revenue data found for {args.currency} in {quarter}")

    print()
    print("✅ Revenue analysis complete! 🎉")


if __name__ == "__main__":
    main()
