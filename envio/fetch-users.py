"""
TODO: Implement user fetching from Envio and Subgraphs
"""

from helpers import (
    add_quarter_argument,
    create_base_parser,
)


def main():
    """Fetch and analyze Quarterly Active Users (can specify quarter or use last 3 months)."""
    parser = create_base_parser("Fetch Quarterly MAUs from Envio and Subgraphs")
    add_quarter_argument(parser)
    args = parser.parse_args()

    # TODO: Implement user fetching logic
    print("User fetching not yet implemented")


if __name__ == "__main__":
    main()
