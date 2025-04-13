import os
import pandas as pd
import sys
from dune_config import get_dune_client
from typing import cast

QUERIES_DIR = os.path.join(os.path.dirname(__file__), "..", "queries")
dune = get_dune_client()


def main():
    """
    Returns the first 20 rows of results by running a query from your `/queries` folder.
    This uses Dune API credits.
    """

    # get id passed in python script invoke
    id = sys.argv[1]

    files = os.listdir(QUERIES_DIR)
    found_files = [
        file for file in files if str(id) == file.split("___")[-1].split(".")[0]
    ]

    if len(found_files) != 0:
        query_file = os.path.join(QUERIES_DIR, found_files[0])

        print("getting 20 line preview for query {}...".format(id))

        with open(query_file, "r", encoding="utf-8") as file:
            query_text = file.read()

        print("select * from (\n" + query_text + "\n) limit 20")

        results = dune.run_sql("select * from (\n" + query_text + "\n) limit 20")
        if results.result is None:
            print("No results found")
        else:
            # print(results.result.rows)
            results = pd.DataFrame(data=results.result.rows)
            print("\n")
            print(results)
            print("\n")
            print(results.describe())
            print("\n")
            print(results.info())
    else:
        print("query id file not found, try again")


if __name__ == "__main__":
    main()
