with acceptance as (

    select
        *
    from
        {{ ref('stg_globepay_acceptance_report') }}

),

chargeback as (

    select
        -- we only need the ref and the flag
        external_ref,
        has_chargeback
    from
        {{ ref('stg_globepay_chargeback') }}

)

select
    -- key fields from acceptance model
    acc.external_ref,
    acc.transaction_at,
    acc.state,
    acc.state = 'ACCEPTED' as is_accepted,
    acc.state = 'DECLINED' as is_declined,
    acc.status,
    acc.is_cvv_provided,
    acc.local_amount,
    acc.currency,
    acc.amount_in_usd,
    acc.country,
    acc.source,

    -- boolean flag from chargeback model (will be true, false, or null)
    chg.has_chargeback,

    -- helper columns for easy aggregation in looker studio
    -- this logic lives in dbt so it's consistent
    case
        when acc.state = 'DECLINED' then acc.amount_in_usd
        else 0
    end as declined_amount_usd,
    
    case
        when acc.state = 'ACCEPTED' then acc.amount_in_usd
        else 0
    end as accepted_amount_usd,
    
    case
        -- we only count the amount if the chargeback flag is true
        when chg.has_chargeback = true then acc.amount_in_usd
        else 0
    end as chargeback_amount_usd

from
    acceptance as acc
left join
    chargeback as chg
        on acc.external_ref = chg.external_ref