"""
TODO: Implement transaction fetching from Envio
"""

from helpers import (
    add_quarter_argument,
    create_base_parser,
)


def main():
    """Fetch and analyze Quarterly Transaction counts (can specify quarter or use last 3 months)."""
    parser = create_base_parser("Fetch Quarterly Transactions from Envio")
    add_quarter_argument(parser)
    args = parser.parse_args()

    # TODO: Implement transaction fetching logic
    print("Transaction fetching not yet implemented")


if __name__ == "__main__":
    main()
