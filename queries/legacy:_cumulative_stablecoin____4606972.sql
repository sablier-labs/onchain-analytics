-- part of a query repo: https://github.com/sablier-labs/onchain-analytics
-- query name: Legacy: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606972

SELECT SUM(STABLECOIN_DEPOSIT)
FROM
    QUERY_4596310 -- Legacy: Stream Creation Data
