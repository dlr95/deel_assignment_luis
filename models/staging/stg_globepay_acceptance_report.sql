with source as (

    select
        *
        from {{ source('globepay', 'globepay_acceptance_report_cleaned') }}

),

cleaned_and_renamed as (

    select
        external_ref,
        status,
        source,
        ref as payment_ref,
        cast(date_time as timestamp) as transaction_at,
        state,
        cvv_provided as is_cvv_provided,
        amount as local_amount,
        country,
        currency,
        -- fix the broken json by adding quotes to keys (e.g., cad: -> "cad":)
        regexp_replace(rates, r'([A-Z]{3}):', r'"\1":') as rates_json_string
        from source

),

-- new step to call the macro once and avoid repetition
with_exchange_rate as (

    select
        *,
        -- call the macro to get the exchange rate
        {{ get_exchange_rate('currency', 'rates_json_string') }} as exchange_rate
    
        from cleaned_and_renamed

),

final as (

    select
        -- select all columns from the previous step
        *,

        -- calculate the usd amount using the new exchange_rate column
        safe_divide(
            local_amount,
            exchange_rate
        ) as amount_in_usd

        from with_exchange_rate
)

select 
    * from final