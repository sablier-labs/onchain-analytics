from os import path

# Directory constants
ROOT_DIR = path.join(path.dirname(__file__), "..", "..")
QUERIES_DIR = path.join(ROOT_DIR, "dune", "queries")
QUERIES_FILE = path.join(ROOT_DIR, "queries.yml")
DOTENV_FILE = path.join(ROOT_DIR, ".env")
