import os
import re
import sys
from colorama import init as init_colorama, Fore, Style
from typing import Dict, List, Tuple
from parse_queries import parse_queries

ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
QUERIES_DIR = os.path.join(ROOT_DIR, "queries")
QUERIES_FILE = os.path.join(ROOT_DIR, "queries.yml")


def find_sql_files() -> Dict[int, str]:
    """
    Find all SQL files in the queries directory and extract their query IDs.

    Returns:
        Dictionary mapping query_id to file_path
    """
    sql_files = {}

    for file_name in os.listdir(QUERIES_DIR):
        if file_name.endswith(".sql"):
            # Extract query ID from the file name
            match = re.search(r"___(\d+)\.sql$", file_name)
            if match:
                query_id = int(match.group(1))
                sql_files[query_id] = os.path.join(QUERIES_DIR, file_name)

    return sql_files


def extract_query_name_from_sql(file_path: str) -> str:
    """
    Extract the query name from the SQL file.

    Args:
        file_path: Path to the SQL file

    Returns:
        Query name or empty string if not found
    """
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Look for the query name in the file header comments
    match = re.search(r"--\s*query\s+name:\s*(.*)", content, re.IGNORECASE)
    if match:
        return match.group(1).strip()

    return ""


def extract_inline_references(file_path: str) -> Dict[int, str]:
    """
    Extract all query inline references in a SQL file.
    Looks for patterns like:
    - 'query_1234567 -- Query Name'
    - 'query_1234567 AS q -- Query Name'

    Args:
        file_path: Path to the SQL file

    Returns:
        Dictionary mapping inline referenced query_id to the commented name
    """
    references = {}

    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Pattern for finding query inline references with comments
    # This matches both the versions with and without AS alias
    pattern = r"query_(\d+)(?:\s+AS\s+\w+)?\s+--\s+(.*?)(?:\n|$)"

    for match in re.finditer(pattern, content):
        query_id = int(match.group(1))
        comment_name = match.group(2).strip()
        references[query_id] = comment_name

    return references


def validate_query_names(
    query_ids_with_names: List[Tuple[int, str]], sql_files: Dict[int, str]
) -> List[str]:
    """
    Validate that query names in SQL files match those in the YAML file.

    Args:
        query_ids_with_names: List of tuples (query_id, name) from YAML
        sql_files: Dictionary of query IDs to file paths

    Returns:
        List of error messages
    """
    errors = []
    yaml_query_dict = {query_id: name for query_id, name in query_ids_with_names}

    # Check for queries in YAML but missing SQL files
    for query_id, _ in query_ids_with_names:
        if query_id not in sql_files:
            errors.append(
                f"Query ID {query_id} found in queries.yml but no matching SQL file"
            )

    # Check for SQL files without entries in YAML
    for query_id in sql_files:
        if query_id not in yaml_query_dict:
            errors.append(
                f"SQL file for query ID {query_id} exists but no entry in queries.yml"
            )

    # Check if names match for files that exist in both
    for query_id, yaml_name in query_ids_with_names:
        if query_id in sql_files:
            sql_name = extract_query_name_from_sql(sql_files[query_id])
            # Get relative path from project root
            rel_path = os.path.relpath(sql_files[query_id], ROOT_DIR)

            if not sql_name:
                errors.append(
                    f"Query ID {query_id}: Failed to extract name from SQL file {rel_path}\n"
                )
            elif sql_name != yaml_name:
                errors.append(
                    f"Query ID {query_id}: Name mismatch in file {rel_path} \n"
                    f"  YAML: '{yaml_name}'\n"
                    f"  SQL: '{sql_name}'\n"
                )

    return errors


def validate_inline_references(
    query_ids_with_names: List[Tuple[int, str]], sql_files: Dict[int, str]
) -> List[str]:
    """
    Validate that query inline references in SQL files match the names in the YAML file.

    Args:
        query_ids_with_names: List of tuples (query_id, name) from YAML
        sql_files: Dictionary of query IDs to file paths

    Returns:
        List of error messages
    """
    errors = []
    yaml_query_dict = {query_id: name for query_id, name in query_ids_with_names}

    # For each SQL file, extract query inline references and check against YAML names
    for sql_query_id, sql_file_path in sql_files.items():
        references = extract_inline_references(sql_file_path)
        # Get relative path from project root
        rel_path = os.path.relpath(sql_file_path, ROOT_DIR)

        for ref_query_id, ref_name in references.items():
            if ref_query_id not in yaml_query_dict:
                errors.append(
                    f"File {rel_path}: References unknown query ID {ref_query_id}\n"
                )
                continue

            yaml_name = yaml_query_dict[ref_query_id]
            if ref_name != yaml_name:
                errors.append(
                    f"File {rel_path}: Inline reference name mismatch for query {ref_query_id}\n"
                    f"  YAML: '{yaml_name}'\n"
                    f"  Inline: '{ref_name}'\n"
                )

    return errors


def print_header(text):
    """Print a formatted header."""
    print(f"\n{Fore.CYAN}{'=' * 60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}🔍 {text}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{'=' * 60}{Style.RESET_ALL}")


def main():
    """
    Check consistency of query names between YAML and SQL,
    as well as query inline references within SQL files.
    """
    print_header("QUERY NAME LINTER")

    # Parse YAML file
    query_ids_with_names = parse_queries()
    if not query_ids_with_names:
        print(f"\n{Fore.RED}❌ Error: No queries found in YAML file{Style.RESET_ALL}")
        sys.exit(1)

    # Find SQL files
    sql_files = find_sql_files()

    # Validate query names
    header_errors = validate_query_names(query_ids_with_names, sql_files)

    # Validate query inline references
    reference_errors = validate_inline_references(query_ids_with_names, sql_files)

    # Print summary
    yaml_query_count = len(query_ids_with_names)
    sql_files_count = len(sql_files)

    print(f"\n{Fore.BLUE}📊 SUMMARY:{Style.RESET_ALL}")
    print(f"  • YAML queries: {Fore.YELLOW}{yaml_query_count}{Style.RESET_ALL}")
    print(f"  • SQL files: {Fore.YELLOW}{sql_files_count}{Style.RESET_ALL}")

    # Combine all errors for reporting
    all_errors = header_errors + reference_errors

    if all_errors:
        header_error_count = len(header_errors)
        reference_error_count = len(reference_errors)

        print(f"\n{Fore.RED}❌ Found {len(all_errors)} mismatches:{Style.RESET_ALL}")
        print(f"  • Header mismatches: {Fore.RED}{header_error_count}{Style.RESET_ALL}")
        print(
            f"  • Inline mismatches: {Fore.RED}{reference_error_count}{Style.RESET_ALL}"
        )

        for i, error in enumerate(all_errors, 1):
            print(f"  {i}. {Fore.RED}{error}{Style.RESET_ALL}")
        sys.exit(1)
    else:
        print(
            f"\n{Fore.GREEN}✅ Success! All query names match between YAML and SQL files.{Style.RESET_ALL}"
        )
        print(
            f"{Fore.GREEN}✅ All query inline references within SQL files are consistent.{Style.RESET_ALL}"
        )
        print(
            f"{Fore.GREEN}🎉 All {yaml_query_count} queries are properly named and documented.{Style.RESET_ALL}"
        )


if __name__ == "__main__":
    init_colorama()
    main()
