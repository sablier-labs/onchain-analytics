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


def fetch_transactions(endpoint_key, start_timestamp, end_timestamp):
    """
    Fetch unique transaction count from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        dict: GraphQL response containing UserTransaction aggregate count
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch UserTransaction aggregate with timestamp filtering
    query = gql("""
        query GetTransactions(
            $startTimestamp: numeric!,
            $endTimestamp: numeric!
        ) {
            UserTransaction_aggregate(
                where: {
                    timestamp: { _gte: $startTimestamp, _lte: $endTimestamp }
                }
            ) {
                aggregate {
                    count(columns: [hash], distinct: true)
                }
            }
        }
    """)

    variables = {
        "startTimestamp": start_timestamp,
        "endTimestamp": end_timestamp,
    }

    return execute_graphql_query(client, query, variables, endpoint_key)


def process_transaction_result(result, protocol):
    """Process transaction query result for a specific protocol."""
    if "data" not in result or "UserTransaction_aggregate" not in result["data"]:
        return None

    transaction_count = result["data"]["UserTransaction_aggregate"]["aggregate"]["count"]
    print(f"   ✅ Found {transaction_count:,} transactions for {protocol}")

    return {"transaction_count": transaction_count}


def main():
    """Fetch and analyze Quarterly Transaction counts (last 3 months)."""
    parser = create_base_parser("Fetch Quarterly Transactions from Envio")
    args = parser.parse_args()

    print_header("📊 SABLIER QUARTERLY TRANSACTIONS ANALYTICS")

    # Get last 3 complete months
    months = get_last_quarter_months()
    print(f"📅 Analyzing last quarter months: {', '.join(months)}")
    print()

    from datetime import datetime, timezone

    quarterly_results = {}
    total_quarterly_transactions = 0

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

        # Process all protocols for this month
        month_protocols_data = process_protocols(
            PROTOCOLS,
            fetch_transactions,
            start_timestamp,
            end_timestamp,
            process_result_func=process_transaction_result,
        )

        if not month_protocols_data:
            print(f"❌ No transaction data found for {month}")
            continue

        # Calculate monthly totals
        monthly_total = 0
        for protocol, data in month_protocols_data.items():
            transaction_count = data.get("transaction_count", 0)
            monthly_total += transaction_count

        quarterly_results[month] = {"total_transactions": monthly_total, "protocols": month_protocols_data}
        total_quarterly_transactions += monthly_total

        print(f"📊 {month} Total: {monthly_total:,} transactions")
        print()

    if not quarterly_results:
        print("❌ No transaction data found for any month")
        return

    # Calculate quarterly average
    quarterly_average = total_quarterly_transactions / len(quarterly_results)

    print_section_header("📈 QUARTERLY RESULTS SUMMARY")

    for month, data in quarterly_results.items():
        print(f"📊 {month}: {data['total_transactions']:,} transactions")

    print()
    print(f"🎯 Total across quarter: {total_quarterly_transactions:,} transactions")
    print(f"📊 Average transactions per month: {quarterly_average:,.0f} transactions")
    print()

    # Save detailed results
    print_section_header("💾 SAVING RESULTS")

    quarter_label = months_to_quarter_label(months)
    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "total_quarterly_transactions": total_quarterly_transactions,
        "average_monthly_transactions": round(quarterly_average),
        "monthly_results": quarterly_results,
    }

    save_json_results(
        output_data,
        "envio/transactions",
        f"{quarter_label}.json",
        f"📊 Quarterly Average Transactions: {quarterly_average:,.0f}",
    )

    print()
    print("✅ Quarterly analysis complete! 🎉")


if __name__ == "__main__":
    main()
