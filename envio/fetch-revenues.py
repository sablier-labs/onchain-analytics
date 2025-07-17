import argparse
from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport
from constants import ENDPOINTS


def fetch_revenues(endpoint_key, limit, chain_id):
    """
    Fetch Revenue entities from Envio using Hasura GraphQL.

    Args:
        endpoint_key (str): Which endpoint to use ('airdrops', 'flow', 'lockup')
        limit (int): Number of records to fetch (default: 1000)
        chain_id (int, optional): Filter by chain ID

    Returns:
        dict: GraphQL response containing Revenue entities
    """
    endpoint = ENDPOINTS[endpoint_key]

    # Set up GraphQL client
    transport = RequestsHTTPTransport(url=endpoint)
    client = Client(transport=transport)

    # GraphQL query to fetch Revenue entities
    query = gql("""
        query FetchRevenues($limit: Int!, $chainId: numeric!) {
            Revenue(limit: $limit, where: { chainId: { _eq: $chainId }}) {
                id
                amount
                chainId
                currency
                date
                dateTimestamp
            }
        }
    """)

    try:
        variables = {"limit": limit, "chainId": chain_id}
        result = client.execute(query, variable_values=variables)
        return {"data": result}
    except Exception as e:
        print(f"Error fetching revenues: {e}")
        return None


def main():
    """Fetch and print Revenue entities."""
    parser = argparse.ArgumentParser(description="Fetch Revenue entities from Envio")
    parser.add_argument("--chain-id", type=int, default=1, help="Filter by chain ID (default: 1)")
    parser.add_argument("--limit", type=int, default=1000, help="Number of records to fetch (default: 1000)")
    parser.add_argument(
        "--endpoint",
        default="lockup",
        choices=["airdrops", "flow", "lockup"],
        help="Which endpoint to use (default: lockup)",
    )

    args = parser.parse_args()

    print("Fetching Revenue entities from Envio...")

    # Fetch revenues from specified endpoint
    result = fetch_revenues(args.endpoint, limit=args.limit, chain_id=args.chain_id)

    if not result:
        print("Failed to fetch revenue data")
        return

    if "errors" in result:
        print(f"GraphQL errors: {result['errors']}")
        return

    if "data" not in result or "Revenue" not in result["data"]:
        print("No Revenue data found in response")
        return

    revenues = result["data"]["Revenue"]
    print(f"Successfully fetched {len(revenues)} Revenue entities")

    if not revenues:
        return

    print("\nSample records:")
    for i, revenue in enumerate(revenues[:3]):
        print(
            f"{i + 1}. ID: {revenue['id']}, Amount: {revenue['amount']}, Chain: {revenue['chainId']}, Currency: {revenue['currency']}"
        )


if __name__ == "__main__":
    main()
