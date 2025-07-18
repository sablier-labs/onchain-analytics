from gql import gql

from constants import PROTOCOLS
from helpers import (
    add_month_argument,
    create_base_parser,
    create_graphql_client,
    execute_graphql_query,
    get_most_recent_complete_month,
    handle_period_parsing,
    parse_month,
    print_header,
    print_period_info,
    print_section_header,
    process_protocols,
    save_json_results,
)


def fetch_streams(endpoint_key, start_timestamp, end_timestamp):
    """
    Fetch stream count from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        start_timestamp (int): Start timestamp in Unix format
        end_timestamp (int): End timestamp in Unix format

    Returns:
        dict: GraphQL response containing Stream aggregate count
    """
    client = create_graphql_client(endpoint_key)

    # GraphQL query to fetch Stream aggregate with timestamp filtering
    query = gql("""
        query GetStreams(
            $startTimestamp: numeric!,
            $endTimestamp: numeric!
        ) {
            Stream_aggregate(
                where: {
                    timestamp: { _gte: $startTimestamp, _lte: $endTimestamp }
                }
            ) {
                aggregate {
                    count
                }
            }
        }
    """)

    variables = {
        "startTimestamp": start_timestamp,
        "endTimestamp": end_timestamp,
    }

    return execute_graphql_query(client, query, variables, endpoint_key)


def process_stream_result(result, protocol):
    """Process stream query result for a specific protocol."""
    if "data" not in result or "Stream_aggregate" not in result["data"]:
        return None

    stream_count = result["data"]["Stream_aggregate"]["aggregate"]["count"]
    print(f"   ✅ Found {stream_count:,} streams for {protocol}")

    return {"stream_count": stream_count}


def main():
    """Fetch and analyze Monthly Stream counts."""
    parser = create_base_parser("Fetch Monthly Streams from Envio")
    add_month_argument(parser)
    args = parser.parse_args()

    print_header("🌊 SABLIER MONTHLY STREAMS ANALYTICS")

    # Handle period parsing
    result = handle_period_parsing("month", args.month, parse_month, get_most_recent_complete_month)
    if result[0] is None:
        return

    month, timestamps = result
    start_timestamp, end_timestamp = timestamps

    from datetime import datetime, timezone

    start_date = datetime.fromtimestamp(start_timestamp, tz=timezone.utc)
    end_date = datetime.fromtimestamp(end_timestamp, tz=timezone.utc)

    print_period_info("Month", month, start_date, end_date, start_timestamp, end_timestamp)
    print("\n🔄 Fetching Monthly Streams from Envio for all protocols...")
    print()

    # Process all protocols
    all_protocols_data = process_protocols(
        PROTOCOLS, fetch_streams, start_timestamp, end_timestamp, process_result_func=process_stream_result
    )

    if not all_protocols_data:
        print("❌ No stream data found for any protocol")
        return

    print_section_header("📈 MONTHLY STREAMS RESULTS")
    print(f"🕐 Month: {month}")
    print()

    total_streams = 0
    for protocol, data in all_protocols_data.items():
        stream_count = data.get("stream_count", 0)
        total_streams += stream_count
        print(f"🌊 Protocol {protocol}: {stream_count:,} streams")

    print()
    print(f"🎯 Total Monthly Streams: {total_streams:,}")
    print()

    # Save results
    print_section_header("💾 SAVING RESULTS")

    output_data = {
        "month": month,
        "total_streams": total_streams,
        "protocols": all_protocols_data,
    }

    save_json_results(output_data, "envio/streams", f"{month}.json", f"🌊 Total Monthly Streams: {total_streams:,}")

    print()
    print("✅ Analysis complete! 🎉")


if __name__ == "__main__":
    main()
