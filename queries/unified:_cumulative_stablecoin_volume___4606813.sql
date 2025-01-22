-- part of a query repo
-- query name: Unified: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606813


SELECT (
	(SELECT
		SUM(stablecoinDeposit)
	 FROM query_4580489 -- Lockup: Stream Creation Data
	 ) + (
	 SELECT
	  SUM(stablecoinDeposit)
	 FROM query_4596310 -- Legacy: Stream Creation Data
	 )
) AS cumulative_stablecoin_volume
