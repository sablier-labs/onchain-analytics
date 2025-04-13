import os
from dotenv import load_dotenv
from dune_client.client import DuneClient
from typing import cast


def get_dune_client():
    """
    Initialize and return a Dune client using environment variables.

    Returns:
        DuneClient: Initialized Dune API client
    """
    # Find the .env file in the project root
    dotenv_path = os.path.join(os.path.dirname(__file__), "..", ".env")
    load_dotenv(dotenv_path)
    return cast(DuneClient, DuneClient.from_env())
