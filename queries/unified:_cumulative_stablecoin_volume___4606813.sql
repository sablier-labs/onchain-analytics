-- part of a query repo
-- query name: Unified: Cumulative Stablecoin Volume
-- query link: https://dune.com/queries/4606813


SELECT (
	(SELECT
		SUM(stablecoinDeposit)
	 FROM query_4580489
	 ) + (
	 SELECT
	  SUM(stablecoinDeposit)
	 FROM query_4596310
	 ) + (
	 SELECT
	  SUM(stablecoinDeposit)
	 FROM query_4596391
	 )
) AS cumulative_stablecoin_volume
