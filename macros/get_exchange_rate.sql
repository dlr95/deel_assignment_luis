{% macro get_exchange_rate(currency_col, rates_json_col) %}
    
    -- this macro contains the case statement to safely extract
    -- the correct exchange rate for a given currency.
    case
        when {{ currency_col }} = 'USD' then cast(json_extract_scalar({{ rates_json_col }}, '$.USD') as numeric)
        when {{ currency_col }} = 'CAD' then cast(json_extract_scalar({{ rates_json_col }}, '$.CAD') as numeric)
        when {{ currency_col }} = 'EUR' then cast(json_extract_scalar({{ rates_json_col }}, '$.EUR') as numeric)
        when {{ currency_col }} = 'MXN' then cast(json_extract_scalar({{ rates_json_col }}, '$.MXN') as numeric)
        when {{ currency_col }} = 'SGD' then cast(json_extract_scalar({{ rates_json_col }}, '$.SGD') as numeric)
        when {{ currency_col }} = 'AUD' then cast(json_extract_scalar({{ rates_json_col }}, '$.AUD') as numeric)
        when {{ currency_col }} = 'GBP' then cast(json_extract_scalar({{ rates_json_col }}, '$.GBP') as numeric)
        else null
    end

{% endmacro %}