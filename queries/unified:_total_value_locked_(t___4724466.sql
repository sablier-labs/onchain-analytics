-- part of a query repo
-- query name: Unified: Total Value Locked (TVL)
-- query link: https://dune.com/queries/4724466


SELECT (
    (
        SELECT tvl
        FROM
            query_4611402 -- Lockup: Total Value Locked (TVL)
    ) + (
        SELECT tvl
        FROM
            query_4724394 -- Flow: Total Value Locked (TVL)
    )
)
