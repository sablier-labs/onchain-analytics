-- part of a query repo
-- query name: Unified: Quarterly Transaction Count
-- query link: https://dune.com/queries/4983811


WITH quarters AS (
    SELECT
        DATE_TRUNC('quarter', block_date) AS quarter_start,
        SUM(transaction_count) AS total_transactions
    FROM query_4983787
    WHERE block_date < DATE_TRUNC('quarter', CURRENT_DATE)
    GROUP BY quarter_start
),

ordered_quarters AS (
    SELECT *
    FROM quarters
    ORDER BY quarter_start DESC LIMIT 4
)

SELECT *
FROM ordered_quarters
ORDER BY quarter_start;
