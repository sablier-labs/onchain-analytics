-- part of a query repo
-- query name: Legacy: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606972


SELECT
    SUM(stablecoinDeposit)
FROM
    query_4596310 -- Legacy: Stream Creation Data