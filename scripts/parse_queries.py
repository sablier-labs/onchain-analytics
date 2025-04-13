import os
from typing import Dict, List, Tuple

# Always read from queries.yml in the project root
QUERIES_FILE = os.path.join(os.path.dirname(__file__), "..", "queries.yml")


def parse_queries() -> List[Tuple[int, str]]:
    """
    Parse the YAML file and extract query IDs and names from comments.

    Args:
        file_path: Path to the YAML file

    Returns:
        List of tuples containing (query_id, query_name)
    """
    query_ids_with_names = []

    # If the above approach didn't work, try a different method by reopening the file
    with open(QUERIES_FILE, "r", encoding="utf-8") as file:
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
