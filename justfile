set shell := ["bash", "-euo", "pipefail", "-c"]

# ---------------------------------------------------------------------------- #
#                                 DEPENDENCIES                                 #
# ---------------------------------------------------------------------------- #

# Poetry: https://github.com/python-poetry/poetry
poetry := require("poetry")

# ---------------------------------------------------------------------------- #
#                                    RECIPES                                   #
# ---------------------------------------------------------------------------- #

# Show available commands
default:
    @just --list

# Run all checks
full-check: dune-names-check python-check sql-check
    @echo "All checks complete!"
alias fc := full-check

# Format all files
full-format: python-format sql-format
    @echo "All files formatted!"
alias ff := full-format

# Install dependencies
install:
    poetry install

# Install dependencies and check that the lock file is synced
install-check:
    poetry install && poetry check --lock

# Check Python files
python-check:
    poetry run ruff check .

# Format Python files
python-format:
    poetry run ruff format .

# Check SQL files
sql-check:
    poetry run sqlfluff lint .

# Format SQL files
sql-format:
    poetry run sqlfluff format .

# ---------------------------------------------------------------------------- #
#                                     DUNE                                     #
# ---------------------------------------------------------------------------- #

# Preview a Dune query (pass ID with e.g. `id=123`)
[group("dune")]
dune-preview id:
    poetry run python -u dune/scripts/preview_query.py {{id}}

# Sync Dune query names
[group("dune")]
dune-names-check:
    poetry run python -u dune/scripts/sync_query_names.py --check-only

# Sync Dune query names in local files
[group("dune")]
dune-names-sync:
    poetry run python -u dune/scripts/sync_query_names.py

# Update query names in Dune
[group("dune")]
dune-names-update *args:
    poetry run python -u dune/scripts/update_query_names.py {{ args }}

# Pull queries from Dune
[group("dune")]
dune-pull:
    poetry run python -u dune/scripts/pull_from_dune.py

# Push query SQLs to Dune
[group("dune")]
dune-push:
    poetry run python -u dune/scripts/push_to_dune.py
