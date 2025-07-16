import os
import re
import sys
import argparse
from colorama import init as init_colorama, Fore, Style
from typing import Dict, List, Tuple
from parse_queries import parse_queries
from constants import ROOT_DIR, QUERIES_DIR

# Regex patterns
# Matches SQL filenames with pattern ending in ___<number>.sql to extract the query ID
SQL_FILENAME_PATTERN = r"___(\d+)\.sql$"

# Matches the "query name:" header comment in SQL files
QUERY_NAME_HEADER_PATTERN = r"--\s*query\s+name:\s*(.*)"

# Matches inline query references:
# - query_1234567 -- Query Name
# - query_1234567 AS q -- Query Name
INLINE_REFERENCE_PATTERN = r"query_(\d+)(?:\s+AS\s+\w+)?\s+--\s+(.*?)(?:\n|$)"

# Similar pattern but with capture groups for the replacement function
INLINE_REFERENCE_REPLACE_PATTERN = r"(query_(\d+)(?:\s+AS\s+\w+)?)\s+--\s+(.*?)(?:\n|$)"


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
            match = re.search(SQL_FILENAME_PATTERN, file_name)
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
    match = re.search(QUERY_NAME_HEADER_PATTERN, content, re.IGNORECASE)
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

    for match in re.finditer(INLINE_REFERENCE_PATTERN, content):
        query_id = int(match.group(1))
        comment_name = match.group(2).strip()
        references[query_id] = comment_name

    return references


def validate_query_names(
    query_ids_with_names: List[Tuple[int, str]],
    sql_files: Dict[int, str],
    lint_only: bool,
) -> List[str]:
    """
    Validate that query names in SQL files match those in the YAML file.
    If lint_only is False, it corrects mismatches.

    Args:
        query_ids_with_names: List of tuples (query_id, name) from YAML
        sql_files: Dictionary of query IDs to file paths
        lint_only: If True, only checks for errors without fixing

    Returns:
        List of error messages
    """
    errors = []
    fixes = []
    yaml_query_dict = {query_id: name for query_id, name in query_ids_with_names}

    # Check for queries in YAML but missing SQL files
    for query_id, _ in query_ids_with_names:
        if query_id not in sql_files:
            errors.append(f"Query ID {query_id} found in queries.yml but no matching SQL file")

    # Check for SQL files without entries in YAML
    for query_id in sql_files:
        if query_id not in yaml_query_dict:
            errors.append(f"SQL file for query ID {query_id} exists but no entry in queries.yml")

    # Check if names match for files that exist in both
    for query_id, yaml_name in query_ids_with_names:
        if query_id in sql_files:
            sql_file = sql_files[query_id]
            sql_name = extract_query_name_from_sql(sql_file)
            # Get relative path from project root
            rel_path = os.path.relpath(sql_file, ROOT_DIR)

            if not sql_name:
                errors.append(f"Query ID {query_id}: Failed to extract name from SQL file {rel_path}\n")
                # If fix mode and we can fix this by adding the header
                if not lint_only:
                    fixes.append((query_id, sql_file, yaml_name, "add_header"))
            elif sql_name != yaml_name:
                errors.append(
                    f"Query ID {query_id}: Name mismatch in file {rel_path} \n"
                    f"  YAML: '{yaml_name}'\n"
                    f"  SQL Header: '{sql_name}'\n"
                )
                # Fix the mismatch
                if not lint_only:
                    fixes.append((query_id, sql_file, yaml_name, "update_header"))

    # Apply fixes if not in check-only mode
    if not lint_only:
        for query_id, file_path, yaml_name, fix_type in fixes:
            fix_header_name(file_path, yaml_name, fix_type)

    return errors


def fix_header_name(file_path: str, yaml_name: str, fix_type: str) -> None:
    """
    Fix the query name in the SQL file header.

    Args:
        file_path: Path to the SQL file
        yaml_name: Correct name from YAML
        fix_type: Type of fix (add_header or update_header)
    """
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    if fix_type == "update_header":
        # Replace the existing query name with the correct one
        fixed_content = re.sub(
            QUERY_NAME_HEADER_PATTERN,
            f"\\1 {yaml_name}",
            content,
            flags=re.IGNORECASE,
        )
    else:  # add_header
        # Add the query name header at the beginning of the file
        header = f"-- query name: {yaml_name}\n"
        if content.startswith("--"):
            # Find the end of the header block
            headers_end = 0
            for line in content.split("\n"):
                if line.startswith("--"):
                    headers_end += len(line) + 1  # +1 for newline
                else:
                    break
            # Insert the new header line within the header block
            fixed_content = content[:headers_end] + header + content[headers_end:]
        else:
            # If no headers, add it at the top
            fixed_content = header + content

    # Write the fixed content back to the file
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(fixed_content)

    # Get relative path for printing
    rel_path = os.path.relpath(file_path, ROOT_DIR)
    print(f"{Fore.GREEN}✅ Fixed header in {rel_path}{Style.RESET_ALL}")


def validate_inline_references(
    query_ids_with_names: List[Tuple[int, str]],
    sql_files: Dict[int, str],
    lint_only: bool,
) -> List[str]:
    """
    Validate that query inline references in SQL files match the names in the YAML file.
    If lint_only is False, it corrects mismatches.

    Args:
        query_ids_with_names: List of tuples (query_id, name) from YAML
        sql_files: Dictionary of query IDs to file paths
        lint_only: If True, only checks for errors without fixing

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

        # Track if we need to update this file
        file_needs_update = False

        for ref_query_id, ref_name in references.items():
            if ref_query_id not in yaml_query_dict:
                errors.append(f"File {rel_path}: References unknown query ID {ref_query_id}\n")
                continue

            yaml_name = yaml_query_dict[ref_query_id]
            if ref_name != yaml_name:
                errors.append(
                    f"File {rel_path}: Inline reference name mismatch for query {ref_query_id}\n"
                    f"  YAML: '{yaml_name}'\n"
                    f"  SQL Inline: '{ref_name}'\n"
                )
                # Mark for fixing if not in check-only mode
                if not lint_only:
                    file_needs_update = True

        # Apply fixes if needed and not in check-only mode
        if not lint_only and file_needs_update:
            fix_inline_references(sql_file_path, yaml_query_dict)

    return errors


def fix_inline_references(file_path: str, yaml_query_dict: Dict[int, str]) -> None:
    """
    Fix inline references in a SQL file.

    Args:
        file_path: Path to the SQL file
        yaml_query_dict: Dictionary of query IDs to correct names
    """
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    def replace_reference(match):
        query_ref = match.group(1)  # The 'query_123456 AS x' part
        query_id = int(match.group(2))  # Just the ID

        if query_id in yaml_query_dict:
            correct_name = yaml_query_dict[query_id]
            return f"{query_ref} -- {correct_name}" + (match.group(0)[-1] if match.group(0).endswith("\n") else "")
        else:
            # If we don't have a name for this ID, leave it unchanged
            return match.group(0)

    # Replace all references with correct names
    fixed_content = re.sub(INLINE_REFERENCE_REPLACE_PATTERN, replace_reference, content)

    # Write the fixed content back to the file
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(fixed_content)

    # Get relative path for printing
    rel_path = os.path.relpath(file_path, ROOT_DIR)
    print(f"{Fore.GREEN}✅ Fixed inline references in {rel_path}{Style.RESET_ALL}")


def print_header(text):
    """Print a formatted header."""
    print(f"\n{Fore.CYAN}{'=' * 60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}🔍 {text}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{'=' * 60}{Style.RESET_ALL}")


def main():
    """
    Check consistency of query names between YAML and SQL,
    as well as query inline references within SQL files.
    Optionally fix inconsistencies.
    """
    parser = argparse.ArgumentParser(description="Sync and validate query names between YAML and SQL files")
    parser.add_argument("--check-only", action="store_true", help="Check only mode (don't fix errors)")
    args = parser.parse_args()

    mode_text = "QUERY NAME CHECK" if args.check_only else "QUERY NAME SYNC"
    print_header(mode_text)

    # Parse YAML file
    query_ids_with_names = parse_queries()
    if not query_ids_with_names:
        print(f"\n{Fore.RED}❌ Error: No queries found in YAML file{Style.RESET_ALL}")
        sys.exit(1)

    # Find SQL files
    sql_files = find_sql_files()

    # Validate query names
    header_errors = validate_query_names(query_ids_with_names, sql_files, args.check_only)

    # Validate query inline references
    reference_errors = validate_inline_references(query_ids_with_names, sql_files, args.check_only)

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

        if args.check_only:
            print(f"\n{Fore.RED}❌ Found {len(all_errors)} mismatches:{Style.RESET_ALL}")
            print(f"  • SQL Header mismatches: {Fore.RED}{header_error_count}{Style.RESET_ALL}")
            print(f"  • SQL Inline mismatches: {Fore.RED}{reference_error_count}{Style.RESET_ALL}")

            for i, error in enumerate(all_errors, 1):
                print(f"  {i}. {Fore.RED}{error}{Style.RESET_ALL}")
            sys.exit(1)
        else:
            print(f"\n{Fore.GREEN}✅ Fixed {len(all_errors)} mismatches:{Style.RESET_ALL}")
            print(f"  • SQL Header fixes: {Fore.GREEN}{header_error_count}{Style.RESET_ALL}")
            print(f"  • SQL Inline fixes: {Fore.GREEN}{reference_error_count}{Style.RESET_ALL}")
            print(f"\n{Fore.GREEN}🎉 All queries are now consistent with the YAML definitions.{Style.RESET_ALL}")
    else:
        print(f"\n{Fore.GREEN}✅ Success! All query names match between YAML and SQL files.{Style.RESET_ALL}")
        print(f"{Fore.GREEN}✅ All query inline references within SQL files are consistent.{Style.RESET_ALL}")
        print(f"{Fore.GREEN}🎉 All {yaml_query_count} queries are properly named and documented.{Style.RESET_ALL}")


if __name__ == "__main__":
    init_colorama()
    main()
