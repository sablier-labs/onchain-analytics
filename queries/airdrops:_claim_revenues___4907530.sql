-- part of a query repo
-- query name: Airdrops: Claim Revenues
-- query link: https://dune.com/queries/4907530


SELECT 
  t.chain,
  t.currency,
  DATE_TRUNC('day', t.block_time) AS revenue_date,
  t.airdrop_fee AS fee,
  p.price AS usd_asset_price,
  t.airdrop_fee * p.price AS usd_revenue
FROM 
  query_4676715 t
LEFT JOIN (
  SELECT DISTINCT (DATE_TRUNC('day', timestamp), symbol, contract_address),
    DATE_TRUNC('day', timestamp) AS day,
    symbol,
    contract_address,
    price
  FROM prices.day
  WHERE contract_address = 0x0000000000000000000000000000000000000000
) p 
ON DATE_TRUNC('day', t.block_time) = p.day
AND t.currency = p.symbol
AND p.contract_address = 0x0000000000000000000000000000000000000000

