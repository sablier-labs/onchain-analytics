# Onchain Analytics

A repo for managing Sablier's [Dune queries](https://dune.mintlify.app/api-reference/crud/endpoint/create), forked from
[DuneQueryRepo](https://github.com/duneanalytics/DuneQueryRepo).

## Set Up

1. Generate an API key in the Dune UI, and put it in a `.env` file. You can create a key under your Dune team settings.
   _For this repo to work, the API key must be from a Plus plan._

2. Type your intended query ids into the `queries.yml` file. The id can be found from the link
   `https://dune.com/queries/<query_id>/...`. If you're creating this for a dashboard, go to the dashboard you want to
   create a repo and click on the "GitHub" button in the top right of your dashboard to see the query ids.

3. Then, run `pull_from_dune.py` to bring in all queries into the `/queries` folder.

### Updating Queries

Make any changes you need to directly in the repo. Then, any time you push a commit to remote, the `push_to_dune.py`
script will run in CI and push your changes to Dune. You can also run this script manually if you want.

## Scripts

You can run these scripts using `poetry run python scripts/<script_name>.py`.

| Script              | Action                                                                                                           |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `preview_query.py`  | Returns the first 20 rows of results by running a query from your `/queries` folder. This uses Dune API credits. |
| `pull_from_dune.py` | Updates or adds queries to Dune based on the ids in `queries.yml`                                                |
| `push_to_dune.py`   | Updates queries to Dune based on the files in the `/queries` folder                                              |

## Things to Be Aware of

💡: Names of queries are pulled into the file name the first time `pull_from_dune.py` is run. Changing the file name in
app or in folder will not affect each other (they aren't synced). **Make sure you leave the `___id.sql` at the end of
the file, otherwise the scripts will break!**

🟧: Make sure to leave in the comment `-- already part of a query repo` at the top of your file. This will hopefully
help prevent others from using it in more than one repo.

➕: If you want to add a query, add it in Dune UI first, then pull the query id from the URL
(`dune.com/queries/{id}/other_stuff`) into `queries.yml`.

🛑: If you accidentally merge a PR or push a commit that messes up your query in Dune, you can roll back any changes
using [query version history](https://dune.com/docs/app/query-editor/version-history).

## Contributing

Feel free to dive in! [Open](https://github.com/sablier-labs/onchain-analytics/issues/new) an issue,
[start](https://github.com/sablier-labs/onchain-analytics/discussions/new) a discussion or submit a PR. For any informal
concerns or feedback, please join our [Discord server](https://discord.gg/bSwRCwWRsT).

### Development Commands

#### Format Python

```sh
poetry run black ./scripts/**/*.py
```

#### Format SQL

```sh
poetry run sqlfluff format ./queries/**/*.sql
```

#### Lint Python

```sh
poetry run black --check ./scripts/**/*.py
```

#### Lint SQL

```sh
poetry run sqlfluff lint ./queries/**/*.sql
```

## License

This project is licensed under MIT.
