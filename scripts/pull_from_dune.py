import os
import yaml
from dune_config import get_dune_client


ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
QUERIES_DIR = os.path.join(ROOT_DIR, "queries")
dune = get_dune_client()


def save_query_to_file(query, found_files):
    """
    Save the query to a file, either updating an existing file or creating a new one.

    Args:
        query: Dune query object
        found_files: List of existing files that match the query ID
    """

    if len(found_files) != 0:
        # Update existing file
        file_path = os.path.join(QUERIES_DIR, found_files[0])

        print("UPDATE: existing query file: {}".format(found_files[0]))
        with open(file_path, "r+", encoding="utf-8") as file:
            # if "query repo:" is in the file, then don't add the text header again
            if "-- part of a query repo" in query.sql:
                file.write(query.sql)
            else:
                file.write(
                    f"-- part of a query repo\n-- query name: {query.base.name}\n-- query link: https://dune.com/queries/{query.base.query_id}\n\n\n{query.sql}"
                )
    else:
        # Create new file and directories if they don't exist
        new_file = f'{query.base.name.replace(" ", "_").lower()[:30]}___{query.base.query_id}.sql'
        file_path = os.path.join(QUERIES_DIR, new_file)
        os.makedirs(os.path.dirname(file_path), exist_ok=True)

        if "-- part of a query repo" in query.sql:
            print("WARNING!!! This query is part of a query repo")
            with open(file_path, "w", encoding="utf-8") as file:
                file.write(
                    f"-- WARNING: this query may be part of multiple repos\n{query.sql}"
                )
        else:
            with open(file_path, "w", encoding="utf-8") as file:
                file.write(
                    f"-- part of a query repo\n-- query name: {query.base.name}\n-- query link: https://dune.com/queries/{query.base.query_id}\n\n\n{query.sql}"
                )
        print("CREATE: new query file: {}".format(new_file))


def main():
    """
    Pulls queries from Dune API and saves them to the `/queries` folder.
    """
    # Read the queries.yml file
    QUERIES_FILE = os.path.join(ROOT_DIR, "queries.yml")
    with open(QUERIES_FILE, "r", encoding="utf-8") as file:
        data = yaml.safe_load(file)

    # Extract the query_ids from the data
    query_ids = [id for id in data["query_ids"]]

    for id in query_ids:
        query = dune.get_query(id)
        print("PROCESSING: query {}, {}".format(query.base.query_id, query.base.name))

        # Check if query file exists in /queries folder
        files = os.listdir(QUERIES_DIR)
        found_files = [
            file for file in files if str(id) == file.split("___")[-1].split(".")[0]
        ]

        save_query_to_file(query, found_files)


if __name__ == "__main__":
    main()
