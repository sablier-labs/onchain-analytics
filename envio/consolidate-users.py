import json
import os

from helpers import (
    add_quarter_argument,
    create_base_parser,
    get_last_quarter_months,
    months_to_quarter_label,
    parse_quarter_to_months,
    print_header,
    print_section_header,
    save_json_results,
)


def load_json_file(file_path):
    """
    Load JSON data from a file.

    Args:
        file_path (str): Path to the JSON file

    Returns:
        dict: JSON data or None if file doesn't exist or has errors
    """
    if not os.path.exists(file_path):
        return None

    try:
        with open(file_path, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"❌ Error loading {file_path}: {e}")
        return None


def main():
    """Consolidate user data from main users file and extra users file."""
    parser = create_base_parser("Consolidate main and extra user data files")
    add_quarter_argument(parser)
    args = parser.parse_args()

    print_header("🔗 SABLIER USER DATA CONSOLIDATION")

    # Determine which quarter to consolidate
    if args.quarter:
        quarter_str = args.quarter
        print(f"📅 Quarter specified: {quarter_str}")

        try:
            months, quarter_label = parse_quarter_to_months(quarter_str)
        except ValueError as e:
            print(f"❌ Error parsing quarter: {e}")
            print("   Expected format: YYYY-qN (e.g., 2025-q1)")
            return
    else:
        # Get last 3 complete months
        months = get_last_quarter_months()
        quarter_label = months_to_quarter_label(months)
        print(f"📅 Using most recent complete quarter: {quarter_label}")

    print(f"📅 Consolidating data for: {quarter_label}")
    print()

    # Define file paths
    main_users_file = f"envio/users/{quarter_label}.json"
    extra_users_file = f"envio/users/extra-{quarter_label}.json"

    print_section_header("📂 LOADING DATA FILES")

    # Load main users data
    print(f"📥 Loading main users file: {main_users_file}")
    main_data = load_json_file(main_users_file)
    if main_data is None:
        print(f"❌ Could not load main users file: {main_users_file}")
        return

    main_addresses = set(main_data.get("all_unique_addresses", []))
    print(f"   ✅ Found {len(main_addresses):,} unique addresses in main file")

    # Load extra users data
    print(f"📥 Loading extra users file: {extra_users_file}")
    extra_data = load_json_file(extra_users_file)
    if extra_data is None:
        print(f"❌ Could not load extra users file: {extra_users_file}")
        return

    extra_addresses = set(extra_data.get("all_unique_addresses", []))
    print(f"   ✅ Found {len(extra_addresses):,} unique addresses in extra file")

    print()

    # Consolidate addresses
    print_section_header("🔄 CONSOLIDATING ADDRESSES")

    # Combine all addresses and deduplicate
    all_addresses = main_addresses.union(extra_addresses)
    overlap_addresses = main_addresses.intersection(extra_addresses)

    print(f"📊 Main file addresses: {len(main_addresses):,}")
    print(f"📊 Extra file addresses: {len(extra_addresses):,}")
    print(f"📊 Overlapping addresses: {len(overlap_addresses):,}")
    print(f"📊 Total unique addresses: {len(all_addresses):,}")

    # Calculate additional addresses from extra file
    additional_addresses = extra_addresses - main_addresses
    print(f"📊 Additional addresses from extra file: {len(additional_addresses):,}")

    print()

    # Convert to sorted list for consistent output
    all_addresses_list = sorted(list(all_addresses))
    additional_addresses_list = sorted(list(additional_addresses))

    # Create consolidated output data
    print_section_header("📊 CONSOLIDATION RESULTS")

    output_data = {
        "quarter_months": months,
        "quarter_label": quarter_label,
        "consolidation_summary": {
            "main_file_addresses": len(main_addresses),
            "extra_file_addresses": len(extra_addresses),
            "overlapping_addresses": len(overlap_addresses),
            "additional_addresses_from_extra": len(additional_addresses),
            "total_unique_addresses": len(all_addresses),
        },
        "source_files": {
            "main_users_file": main_users_file,
            "extra_users_file": extra_users_file,
        },
        "all_unique_addresses": all_addresses_list,
        "additional_addresses_from_extra": additional_addresses_list,
    }

    # Copy metadata from source files
    if "quarter_months" in main_data:
        output_data["main_file_metadata"] = {
            "quarter_months": main_data["quarter_months"],
            "total_unique_quarterly_users": main_data.get("total_unique_quarterly_users", 0),
            "average_monthly_users": main_data.get("average_monthly_users", 0),
        }

    if "airdrops_endpoints" in extra_data:
        output_data["extra_file_metadata"] = {
            "airdrops_endpoints": extra_data["airdrops_endpoints"],
            "lockup_endpoints": extra_data["lockup_endpoints"],
            "total_unique_addresses": extra_data.get("total_unique_addresses", 0),
        }

    print(f"🎯 Total unique addresses after consolidation: {len(all_addresses):,}")
    print(f"📈 Additional addresses gained: {len(additional_addresses):,}")
    print(f"📊 Coverage improvement: {(len(additional_addresses) / len(main_addresses) * 100):.1f}%")

    print()

    # Save consolidated results
    print_section_header("💾 SAVING CONSOLIDATED RESULTS")

    save_json_results(
        output_data,
        "envio/users",
        f"consolidated-{quarter_label}.json",
        f"🎯 Total Consolidated Addresses: {len(all_addresses):,}",
    )

    print()
    print("✅ User data consolidation complete! 🎉")


if __name__ == "__main__":
    main()