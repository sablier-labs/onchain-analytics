import os
import yaml
from dune_config import get_dune_client

ROOT_DIR = os.path.join(os.path.dirname(__file__), "..")
QUERIES_DIR = os.path.join(ROOT_DIR, "queries")
QUERIES_FILE = os.path.join(ROOT_DIR, "queries.yml")
dune = get_dune_client()


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

                # Update existing file
                dune.update_query(
                    query.base.query_id,
                    query_sql=text,
                )
                print("SUCCESS: updated query {} to Dune".format(query.base.query_id))
        else:
            print("ERROR: file not found, query id {}".format(query.base.query_id))


if __name__ == "__main__":
    main()
