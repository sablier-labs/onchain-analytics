# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository manages Sablier Protocol's onchain analytics through Dune queries. It synchronizes SQL queries between
the local repository and Dune Analytics platform, allowing for version control and CI/CD workflows for analytics
queries.

## Architecture

The codebase is structured around two main components:

1. **Dune Integration (`dune/` directory)**:

   - `dune/queries/` - Contains SQL query files synchronized with Dune Analytics
   - `dune/scripts/` - Python scripts for managing Dune API interactions
   - Query files follow naming pattern: `category:_query_name___<query_id>.sql`

2. **Envio Integration (`envio/` directory)**:
   - Contains Python scripts for fetching stream data from Envio
   - Separate analytics pipeline for blockchain data

## Key Files

- `queries.yml` - Central source of truth for all query IDs and names
- `justfile` - Task runner with all available commands
- `pyproject.toml` - Python project configuration with Poetry
- Query files must preserve the `___<id>.sql` suffix for scripts to work

## Common Commands

### Development Setup

```bash
just install              # Install dependencies
just install-check        # Install and verify lock file
```

### Code Quality

```bash
just full-check          # Run all checks (Python, SQL, Dune names)
just full-format         # Format all files
just python-check        # Check Python files with ruff
just python-format       # Format Python files
just sql-check           # Check SQL files with sqlfluff
just sql-format          # Format SQL files
```

### Dune Operations

```bash
just dune-pull           # Pull queries from Dune to local files
just dune-push           # Push local SQL changes to Dune
just dune-names-check    # Check query names are synchronized
just dune-names-sync     # Sync query names in local files
just dune-names-update   # Update query names in Dune
just dune-preview id=123 # Preview specific query by ID
```

## Development Workflow

1. **Adding New Query**: Create query in Dune UI first, then add ID to `queries.yml`
2. **Modifying Queries**: Edit SQL files directly in `dune/queries/`, then run `just dune-push`
3. **Query Names**: Use `queries.yml` as source of truth, sync with `just dune-names-sync`

## Important Notes

- Requires Dune Plus API key in `.env` file
- Query file names must preserve `___<id>.sql` suffix
- Comments like `-- already part of a query repo` should be preserved
- Changes pushed to main branch automatically sync to Dune via CI
- Query version history in Dune can rollback problematic changes
