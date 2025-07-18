from gql import gql

from constants import PROTOCOLS
from helpers import (
    create_base_parser,
    create_graphql_client,
    execute_graphql_query,
    get_last_quarter_months,
    months_to_quarter_label,
    parse_month,
    print_header,
    print_period_info,
    print_section_header,
    process_protocols,
    save_json_results,
)


def fetch_users(endpoint_key, start_timestamp, end_timestamp):
    """
    Fetch unique active users from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        dict: GraphQL response containing User aggregate count
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch User entities with transaction timestamp filtering
    query = gql("""
        query GetUsers(
            $startTimestamp: numeric!,
            $endTimestamp: numeric!
        ) {
            User_aggregate(
                where: {
                    transactions: { timestamp: { _gte: $startTimestamp, _lte: $endTimestamp } }
                }
            ) {
                aggregate {
                    count(columns: [address], distinct: true)
                }
            }
        }
    """)

    variables = {
        "startTimestamp": start_timestamp,
        "endTimestamp": end_timestamp,
    }

    return execute_graphql_query(client, query, variables, endpoint_key)


def process_user_result(result, protocol):
    """Process user query result for a specific protocol."""
    if "data" not in result or "User_aggregate" not in result["data"]:
        return {"user_count": 0}

    aggregate_data = result["data"]["User_aggregate"]["aggregate"]
    user_count = aggregate_data["count"] if aggregate_data else 0

    print(f"   ✅ Found {user_count:,} MAUs for {protocol}")

    return {"user_count": user_count}


def main():
    """Fetch and analyze Quarterly Active Users (last 3 months)."""
    parser = create_base_parser("Fetch Quarterly MAUs from Envio")
    args = parser.parse_args()

    print_header("👥 SABLIER QUARTERLY MAUs ANALYTICS")

    # Get last 3 complete months
    months = get_last_quarter_months()
    print(f"📅 Analyzing last quarter months: {', '.join(months)}")
    print()

    from datetime import datetime, timezone

    quarterly_results = {}
    total_quarterly_sum = 0

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

        # Process all protocols for this month
        month_protocols_data = process_protocols(
            PROTOCOLS, fetch_users, start_timestamp, end_timestamp, process_result_func=process_user_result
        )

        if not month_protocols_data:
            print(f"❌ No user data found for {month}")
            continue

        # Calculate monthly totals
        monthly_total = 0
        for protocol, data in month_protocols_data.items():
            user_count = data.get("user_count", 0)
            monthly_total += user_count

        quarterly_results[month] = {"total_across_protocols": monthly_total, "protocols": month_protocols_data}
        total_quarterly_sum += monthly_total

        print(f"📊 {month} Total: {monthly_total:,} MAUs")
        print()

    if not quarterly_results:
        print("❌ No user data found for any month")
        return

    # Calculate quarterly average
    quarterly_average = total_quarterly_sum / len(quarterly_results)

    print_section_header("📈 QUARTERLY RESULTS SUMMARY")

    for month, data in quarterly_results.items():
        print(f"👥 {month}: {data['total_across_protocols']:,} MAUs")

    print()
    print(f"📊 Total across quarter: {total_quarterly_sum:,} MAUs")
    print(f"📊 Average MAUs per month: {quarterly_average:,.0f} MAUs")
    print()

    # Save detailed results
    print_section_header("💾 SAVING RESULTS")

    quarter_label = months_to_quarter_label(months)
    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "total_quarterly_maus": total_quarterly_sum,
        "average_monthly_maus": round(quarterly_average),
        "monthly_results": quarterly_results,
    }

    save_json_results(
        output_data,
        "envio/users",
        f"{quarter_label}.json",
        f"👥 Quarterly Average MAUs: {quarterly_average:,.0f}",
    )

    print()
    print("✅ Quarterly analysis complete! 🎉")


if __name__ == "__main__":
    main()
