# Development Commands

# Show available commands
default:
    @just --list

# Preview a Dune query (pass ID with e.g. `id=123`)
dune-preview id:
    poetry run python -u scripts/preview_query.py {{id}}

# Pull queries from Dune
dune-pull:
    poetry run python -u scripts/pull_from_dune.py

# Push query SQLs to Dune
dune-push:
    poetry run python -u scripts/pull_from_dune.py

# Update query names on Dune
dune-update-names *ARGS:
    poetry run python -u scripts/update_query_names.py {{ARGS}}

# Install dependencies
install:
    poetry install

# Format Python files
format-python:
    poetry run ruff format scripts/*.py

# Format SQL files
format-sql:
    poetry run sqlfluff format queries/*.sql

# Format all files
format: format-python format-sql
    @echo "All files formatted!"

# Lint query names
lint-names:
    poetry run python -u scripts/sync_names.py --lint

# Lint Python files
lint-python:
    poetry run ruff check scripts/*.py

# Lint SQL files
lint-sql:
    poetry run sqlfluff lint queries/*.sql

# Lint all files
lint: lint-names lint-python lint-sql
    @echo "All linting checks complete!"

# Sync query names
sync-names:
    poetry run python -u scripts/sync_names.py
