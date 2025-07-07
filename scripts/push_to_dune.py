import os
import yaml
import time
from dune_config import get_dune_client

ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
QUERIES_DIR = os.path.join(ROOT_DIR, "queries")
QUERIES_FILE = os.path.join(ROOT_DIR, "queries.yml")
dune = get_dune_client()


def safe_update(query_id, sql, retries=5, delay=2):
    for attempt in range(retries):
        try:
            dune.update_query(query_id, query_sql=sql)
            print(f"SUCCESS: updated query {query_id} to Dune")
            time.sleep(1.5)  # avoid triggering 429 again
            return
        except Exception as e:
            print(f"WARNING: attempt {attempt + 1} failed for query {query_id}: {e}")
            if "429" in str(e).lower():
                time.sleep(delay * (2**attempt))  # exponential backoff
            else:
                break
    print(f"ERROR: failed to update query {query_id} after {retries} retries")


def main():
    """
    Pushes queries from the `/queries` folder to Dune API.
    """

    # Read the queries.yml file
    with open(QUERIES_FILE, "r", encoding="utf-8") as file:
        data = yaml.safe_load(file)

    # Extract the query_ids from the data
    query_ids = [id for id in data["query_ids"]]

    for id in query_ids:
        query = dune.get_query(id)
        print("PROCESSING: query {}, {}".format(query.base.query_id, query.base.name))

        # Check if query file exists in /queries folder
        files = os.listdir(QUERIES_DIR)
        # Find files that match the current query ID
        found_files = [file for file in files if str(id) == file.split("___")[-1].split(".")[0]]

        if len(found_files) != 0:
            file_path = os.path.join(QUERIES_DIR, found_files[0])
            # Read the content of the file
            with open(file_path, "r", encoding="utf-8") as file:
                text = file.read()

                safe_update(query.base.query_id, text)
        else:
            print("ERROR: file not found, query id {}".format(query.base.query_id))


if __name__ == "__main__":
    main()
