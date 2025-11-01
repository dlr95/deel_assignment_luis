with source as (

    select
        *
    from {{ source('globepay', 'globepay_acceptance_report_cleaned') }}

),

cleaned_and_renamed as (

    select
        external_ref,
        status as is_transaction_successful,
        source as payment_source,
        ref as payment_ref,
        cast(date_time as timestamp) as transaction_at,
        state,
        cvv_provided as is_cvv_provided,
        amount as local_amount,
        country,
        currency,
        -- fix the broken json by adding quotes to keys (e.g., CAD: -> "CAD":)
        regexp_replace(rates, r'([A-Z]{3}):', r'"\1":') as rates_json_string
    from source

),

final as (

    select
        *,
        -- now that the json is valid, we can extract the rate and divide
        safe_divide(
            local_amount,
            cast(
                json_extract_scalar(
                    rates_json_string,
                    concat('$.', currency)
                ) as numeric
            )
        ) as amount_in_usd
    from cleaned_and_renamed

)

select * from final
