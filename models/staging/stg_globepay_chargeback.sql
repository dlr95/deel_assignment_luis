with source as (

    select
        *
        from {{ source('globepay', 'globepay_chargeback_report') }}

),

renamed as (

    select
        external_ref,
        status,
        source,
        -- this is the important boolean flag
        chargeback as has_chargeback
    from
        source
)

select
    *
    from renamed