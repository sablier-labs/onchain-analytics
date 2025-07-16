import argparse
import time
from dune_config import get_dune_client
from parse_queries import parse_queries

dune = get_dune_client()


def get_user_confirmation() -> bool:
    """
    Ask the user for confirmation to proceed.

    Returns:
        bool: True if user confirms, False otherwise
    """
    valid_responses = {"yes": True, "y": True, "no": False, "n": False}

    while True:
        response = input("Are you sure you want to update all query names? (y/n): ").lower()
        if response in valid_responses:
            return valid_responses[response]
        print("Please respond with 'yes' or 'no' (or 'y' or 'n')")


def update_query_name(query_id: int, query_name: str) -> bool:
    """
    Update a query name using the Dune API.

    Args:
        query_id: ID of the query to update
        query_name: New name for the query

    Returns:
        True if update was successful, False otherwise
    """
    try:
        dune.update_query(query_id, name=query_name)
        print(f"  ✅ SUCCESS: Updated with name: {query_name}")
        return True
    except Exception as e:
        print(f"  ❌ ERROR: Failed to update: {str(e)}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Update Dune query names based on YAML file")
    parser.add_argument("--dry-run", action="store_true", help="Print actions without making API calls")
    args = parser.parse_args()

    # Ask for user confirmation at the beginning
    if not args.dry_run and not get_user_confirmation():
        print("Operation cancelled by user")
        return

    # Parse the YAML file
    query_ids_with_names = parse_queries()

    if not query_ids_with_names:
        print("No query IDs with names found")
        return

    print(f"🔍 Found {len(query_ids_with_names)} queries to update")
    print("\n🚀 Proceeding with updates...\n")

    success_count = 0
    for query_id, query_name in query_ids_with_names:
        print(f"⚙️  PROCESSING: Query {query_id}")
        if args.dry_run:
            print(f"  📝 Would update with name: {query_name}")
            success_count += 1
            print("-" * 50)
        else:
            success = update_query_name(query_id, query_name)
            if success:
                success_count += 1
            # Add a short delay to avoid rate limiting
            time.sleep(0.5)
            print("-" * 50)


if __name__ == "__main__":
    main()
