-- deel_assignment_luis/analyses/task_2_declined_transactions_over_25_m.sql

with
    reporting as ( select * from {{ ref('rpt_transactions') }} )
    
select 
    country,
    -- declined_amount_usd is calculated in stg_globepay_acceptance_report by considering local amounts and exchange rates
    round(sum(declined_amount_usd),0) as declined_amount_usd
    from reporting
    where is_declined --Not essential, but to ensure we only take declined transactions
    group by country
    having declined_amount_usd > 25000000
    order by declined_amount_usd desc