import argparse
import json
import os
from datetime import datetime, timezone, timedelta

from gql import Client
from gql.transport.requests import RequestsHTTPTransport

from constants import ENDPOINTS


def create_graphql_client(endpoint_key):
    """
    Create a GraphQL client for the specified endpoint.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')

    Returns:
        Client: Configured GraphQL client
    """
    endpoint = ENDPOINTS[endpoint_key]
    transport = RequestsHTTPTransport(url=endpoint)
    return Client(transport=transport)


def execute_graphql_query(client, query, variables, endpoint_key):
    """
    Execute a GraphQL query with error handling.

    Args:
        client (Client): GraphQL client
        query: GraphQL query object
        variables (dict): Query variables
        endpoint_key (str): Endpoint key for error messages

    Returns:
        dict: Query result or None on error
    """
    try:
        result = client.execute(query, variable_values=variables)
        return {"data": result}
    except Exception as e:
        print(f"Error executing query for endpoint {endpoint_key}: {e}")
        return None


def create_base_parser(description):
    """
    Create base argument parser with common options.

    Args:
        description (str): Parser description

    Returns:
        ArgumentParser: Configured parser
    """
    return argparse.ArgumentParser(description=description)


def add_month_argument(parser):
    """Add month argument to parser."""
    parser.add_argument(
        "--month",
        type=str,
        help="Month in format 'YYYY-MM' (e.g., '2025-05'). If not specified, uses most recent complete month.",
    )


def add_quarter_argument(parser):
    """Add quarter argument to parser."""
    parser.add_argument(
        "--quarter",
        type=str,
        help="Quarter in format 'YYYY-qN' (e.g., '2025-q2'). If not specified, uses most recent complete quarter.",
    )


def add_limit_argument(parser, default=1000):
    """Add limit argument to parser."""
    parser.add_argument("--limit", type=int, default=default, help=f"Number of records to fetch (default: {default})")


def print_header(title):
    """Print formatted header."""
    print("\n" + "=" * 80)
    print(title)
    print("=" * 80)


def print_section_header(title):
    """Print formatted section header."""
    print("\n" + title)
    print("=" * 80)


def print_period_info(period_type, period_value, start_time, end_time, start_timestamp=None, end_timestamp=None):
    """
    Print formatted period information.

    Args:
        period_type (str): 'Month' or 'Quarter'
        period_value (str): The period value (e.g., '2025-05' or '2025-q2')
        start_time (datetime): Start datetime
        end_time (datetime): End datetime
        start_timestamp (int, optional): Unix timestamp for start
        end_timestamp (int, optional): Unix timestamp for end
    """
    print(f"📊 Fetching data for {period_value}")
    print(f"   Period: {start_time.strftime('%Y-%m-%d %H:%M:%S')} to {end_time.strftime('%Y-%m-%d %H:%M:%S')}")
    if start_timestamp is not None and end_timestamp is not None:
        print(f"   Unix timestamps: {start_timestamp} to {end_timestamp}")


def handle_period_parsing(period_type, period_value, parse_func, get_recent_func):
    """
    Handle period parsing with error handling.

    Args:
        period_type (str): 'month' or 'quarter'
        period_value (str): Period value or None
        parse_func: Function to parse the period
        get_recent_func: Function to get most recent period

    Returns:
        tuple: (period_value, parsed_timestamps) or None on error
    """
    if period_value:
        print(f"📅 {period_type.title()} specified: {period_value}")
    else:
        period_value = get_recent_func()
        print(f"📅 Using most recent complete {period_type}: {period_value}")

    print()

    try:
        return period_value, parse_func(period_value)
    except ValueError as e:
        print(f"❌ Error parsing {period_type}: {e}")
        return None, None


def process_protocols(protocols, fetch_func, *args, **kwargs):
    """
    Process multiple protocols with consistent error handling.

    Args:
        protocols (list): List of protocol names
        fetch_func: Function to fetch data for a protocol
        *args, **kwargs: Additional arguments for fetch_func

    Returns:
        dict: Results by protocol or None on error
    """
    all_protocols_data = {}

    # Extract process_result_func from kwargs to avoid passing it to fetch_func
    process_result_func = kwargs.pop("process_result_func", lambda x, p: x)

    for protocol in protocols:
        print(f"🔗 Processing protocol: {protocol}")
        print(f"🌐 Endpoint: {ENDPOINTS[protocol]}")

        result = fetch_func(protocol, *args, **kwargs)

        if not result:
            print(f"   ❌ Failed to fetch data for {protocol}")
            print("   🛑 Stopping execution due to error")
            return None

        if "errors" in result:
            print(f"   ❌ GraphQL errors for {protocol}: {result['errors']}")
            print("   🛑 Stopping execution due to error")
            return None

        # Let the specific fetch function handle the result processing
        processed_result = process_result_func(result, protocol)
        if processed_result is None:
            print(f"   ⚠️  No data found for {protocol}")
            continue

        all_protocols_data[protocol] = processed_result
        print()

    return all_protocols_data


def save_json_results(data, output_dir, filename, success_message=None):
    """
    Save results to JSON file with consistent formatting.

    Args:
        data (dict): Data to save
        output_dir (str): Output directory
        filename (str): Filename
        success_message (str, optional): Custom success message

    Returns:
        str: Full file path
    """
    os.makedirs(output_dir, exist_ok=True)

    # Create ordered dict with generated_at at the top
    from collections import OrderedDict

    ordered_data = OrderedDict()

    # Add generated timestamp at the top with clean format (HH:MM:SS)
    now = datetime.now(timezone.utc)
    clean_timestamp = now.strftime("%Y-%m-%d %H:%M:%S UTC")
    ordered_data["generated_at"] = clean_timestamp

    # Add the rest of the data
    for key, value in data.items():
        ordered_data[key] = value

    filepath = f"{output_dir}/{filename}"
    with open(filepath, "w") as f:
        json.dump(ordered_data, f, indent=2, default=str)

    print(f"📁 Results saved to: {filepath}")
    if success_message:
        print(success_message)

    return filepath


def parse_quarter(quarter_str):
    """
    Parse quarter string like '2025-q2' into start and end timestamps.

    Args:
        quarter_str (str): Quarter in format 'YYYY-qN' (e.g., '2025-q2')

    Returns:
        tuple: (start_timestamp, end_timestamp) in seconds
    """
    year, quarter = quarter_str.lower().split("-q")
    year = int(year)
    quarter = int(quarter)

    if quarter not in [1, 2, 3, 4]:
        raise ValueError("Quarter must be 1, 2, 3, or 4")

    # Quarter start months: Q1=Jan, Q2=Apr, Q3=Jul, Q4=Oct
    start_month = (quarter - 1) * 3 + 1
    end_month = quarter * 3 + 1
    end_year = year if quarter < 4 else year + 1

    if quarter == 4:
        end_month = 1

    start_date = datetime(year, start_month, 1, tzinfo=timezone.utc)
    end_date = datetime(end_year, end_month, 1, tzinfo=timezone.utc)

    return start_date.isoformat(), end_date.isoformat()


def get_most_recent_complete_quarter():
    """
    Get the most recent complete quarter based on current date.

    Returns:
        str: Quarter string in format 'YYYY-qN'
    """
    now = datetime.now(timezone.utc)
    current_year = now.year
    current_month = now.month

    # Determine current quarter
    current_quarter = (current_month - 1) // 3 + 1

    # If we're in the first month of a quarter, use the previous quarter
    if current_month % 3 == 1:
        if current_quarter == 1:
            return f"{current_year - 1}-q4"
        else:
            return f"{current_year}-q{current_quarter - 1}"
    else:
        # Otherwise, use the current quarter
        return f"{current_year}-q{current_quarter}"


def parse_month(month_str):
    """
    Parse month string like '2025-05' into start and end timestamps.

    Args:
        month_str (str): Month in format 'YYYY-MM' (e.g., '2025-05')

    Returns:
        tuple: (start_timestamp, end_timestamp) in Unix timestamp format
    """
    year, month = month_str.split("-")
    year = int(year)
    month = int(month)

    if month < 1 or month > 12:
        raise ValueError("Month must be between 1 and 12")

    # Start of month: first day at 00:00:00
    start_date = datetime(year, month, 1, tzinfo=timezone.utc)

    # End of month: last day at 23:59:59
    if month == 12:
        end_date = datetime(year + 1, 1, 1, tzinfo=timezone.utc) - timedelta(seconds=1)
    else:
        end_date = datetime(year, month + 1, 1, tzinfo=timezone.utc) - timedelta(seconds=1)

    # Convert to Unix timestamps (numeric values as expected by GraphQL)
    start_timestamp = int(start_date.timestamp())
    end_timestamp = int(end_date.timestamp())

    return start_timestamp, end_timestamp


def get_most_recent_complete_month():
    """
    Get the most recent complete month based on current date.

    Returns:
        str: Month string in format 'YYYY-MM'
    """
    now = datetime.now(timezone.utc)

    # Go back to previous month
    if now.month == 1:
        return f"{now.year - 1}-12"
    else:
        prev_month = now.month - 1
        return f"{now.year}-{prev_month:02d}"


def get_last_quarter_months():
    """
    Get the last 3 complete months in chronological order.

    Returns:
        list: List of month strings in format 'YYYY-MM'
    """
    now = datetime.now(timezone.utc)
    months = []

    for i in range(3, 0, -1):  # Go back 3, 2, 1 months
        target_date = now
        for _ in range(i):
            if target_date.month == 1:
                target_date = target_date.replace(year=target_date.year - 1, month=12)
            else:
                target_date = target_date.replace(month=target_date.month - 1)

        months.append(f"{target_date.year}-{target_date.month:02d}")

    return months


def months_to_quarter_label(months):
    """
    Convert a list of 3 months to quarter format like '2025-q2'.

    Args:
        months (list): List of 3 month strings in format 'YYYY-MM'

    Returns:
        str: Quarter label in format 'YYYY-qN'
    """
    if len(months) != 3:
        # Fallback to first_to_last format if not exactly 3 months
        return f"{months[0]}_to_{months[-1]}"

    # Get the middle month to determine the quarter
    middle_month = months[1]  # Use middle month for quarter determination
    year, month = middle_month.split("-")
    month = int(month)

    # Determine quarter based on middle month
    quarter = (month - 1) // 3 + 1

    return f"{year}-q{quarter}"


def parse_quarter_to_months(quarter_str):
    """
    Parse quarter string and return the constituent months.

    Args:
        quarter_str (str): Quarter in format 'YYYY-qN' (e.g., '2025-q1')

    Returns:
        tuple: (months_list, quarter_label)
    """
    # Use parse_quarter helper to validate the quarter format
    start_iso, end_iso = parse_quarter(quarter_str)

    # Extract year and quarter number for month calculation
    year, quarter_num = quarter_str.lower().split("-q")
    year = int(year)
    quarter_num = int(quarter_num)

    # Calculate the three months of the quarter
    start_month = (quarter_num - 1) * 3 + 1
    months = []
    for i in range(3):
        month_num = start_month + i
        months.append(f"{year}-{month_num:02d}")

    return months, quarter_str
