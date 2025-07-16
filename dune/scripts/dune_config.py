from dotenv import load_dotenv
from dune_client.client import DuneClient
from typing import cast
from constants import DOTENV_FILE


def get_dune_client():
    """
    Initialize and return a Dune client using environment variables.

    Returns:
        DuneClient: Initialized Dune API client
    """
    # Find the .env file in the project root
    load_dotenv(DOTENV_FILE)
    return cast(DuneClient, DuneClient.from_env())
