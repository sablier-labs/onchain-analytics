from dune_client.client import DuneClient
import yaml
import os
from typing import cast, List, Tuple
import argparse
import sys
import codecs
from dotenv import load_dotenv

# Set the default encoding to UTF-8
sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())  # type: ignore


def get_user_confirmation() -> bool:
    """
    Ask the user for confirmation to proceed.

    Returns:
        bool: True if user confirms, False otherwise
    """
    valid_responses = {"yes": True, "y": True, "no": False, "n": False}

    while True:
        response = input(
            "Are you sure you want to update all query names? (y/n): "
        ).lower()
        if response in valid_responses:
            return valid_responses[response]
        print("Please respond with 'yes' or 'no' (or 'y' or 'n')")


def parse_yaml_file(file_path: str) -> List[Tuple[int, str]]:
    """
    Parse the YAML file and extract query IDs and names from comments.

    Args:
        file_path: Path to the YAML file

    Returns:
        List of tuples containing (query_id, query_name)
    """
    with open(file_path, "r", encoding="utf-8") as file:
        yaml_content = yaml.safe_load(file)

    query_ids_with_names = []

    # If the above approach didn't work, try a different method by reopening the file
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    for line in lines:
        line = line.strip()
        if line.startswith("-") and "#" in line:
            parts = line.split("#", 1)
            id_part = parts[0].strip().replace("-", "").strip()
            name_part = parts[1].strip()
            try:
                query_id = int(id_part)
                query_ids_with_names.append((query_id, name_part))
            except ValueError:
                pass

    return query_ids_with_names


def main():
    # Ask for user confirmation at the beginning
    if not get_user_confirmation():
        print("Operation cancelled by user")
        return

    # Load environment variables from .env file after confirmation
    dotenv_path = os.path.join(os.path.dirname(__file__), "..", ".env")
    load_dotenv(dotenv_path)
    dune = cast(DuneClient, DuneClient.from_env())

    # Always read from queries.yml in the project root
    queries_path = os.path.join(os.path.dirname(__file__), "..", "queries.yml")

    # Parse the YAML file
    query_ids_with_names = parse_yaml_file(queries_path)

    if not query_ids_with_names:
        print(f"No query IDs with names found in {queries_path}")
        return

    print(f"Found {len(query_ids_with_names)} queries to update")
    # Pretty print query_ids_with_names
    for query_id, name in query_ids_with_names:
        print(f"Query ID: {query_id}, Name: {name}")

    print("Proceeding with updates...")
    # The rest of the update logic would go here


if __name__ == "__main__":
    main()
