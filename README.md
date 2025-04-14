# Onchain Analytics

A repo for keeping track of Sablier's [Dune queries](https://dune.mintlify.app/api-reference/crud/endpoint/create),
forked from [DuneQueryRepo](https://github.com/duneanalytics/DuneQueryRepo).

## Set Up

> [!NOTE] For this repo to work, the API key must be from a [Dune Plus](https://dune.com/pricing) plan.

1. Generate an API key in the Dune UI, and put it in a `.env` file. You can create a key under your Dune team settings.

2. Type your intended query ids into the `queries.yml` file. The id can be found from the link
   `https://dune.com/queries/<query_id>/...`. If you're creating this for a dashboard, go to the dashboard you want to
   create a repo and click on the "GitHub" button in the top right of your dashboard to see the query ids.

3. Then, run `pull_from_dune.py` to bring in all queries into the `/queries` folder.

### Updating Query SQL

Make any SQL changes you need to directly in the repo. Then, any time you push a commit to remote, the `push_to_dune.py`
script will run in CI and push your changes to Dune. You can also run this script manually if you want.

### Updating Query Names

Run the `update_query_names.py` script to update the query names on Dune using the names written in the `queries.yml`
file.

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

Feel free to dive in! [Open](../../issues/new) an issue, [start](../../discussions/new) a discussion or submit a PR. For
any informal concerns or feedback, please join our [Discord server](https://discord.gg/bSwRCwWRsT).

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Python 3.12](https://python.org/)
- [Poetry 1.x](https://python-poetry.org)
- [Just](https://github.com/casey/just)
- [Prettier](https://prettier.io)

### Commands

Install dependencies:

```shell
just install
```

To see all available commands, run:

```shell
just default
```

## License

This project is licensed under MIT.
