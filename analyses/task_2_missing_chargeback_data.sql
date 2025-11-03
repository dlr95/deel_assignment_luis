with 
    acceptance as ( select * from {{ ref('stg_globepay_acceptance_report') }} ),
    chargeback as ( select * from {{ ref('stg_globepay_chargeback') }} )


select 
    external_ref 
    from acceptance
    where not exists (
                       select 1
                       from chargeback
                       where chargeback.external_ref = acceptance.external_ref
           )