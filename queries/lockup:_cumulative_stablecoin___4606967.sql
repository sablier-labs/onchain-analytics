-- part of a query repo
-- query name: Lockup: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606967


SELECT SUM(stablecoin_deposit)
FROM
    query_4580489 -- Lockup: Stream Creation Data
