-- deel_assignment_luis/analyses/task_2_acceptance_rate.sql
with
    reporting as ( select * from {{ ref('rpt_transactions') }} )
    
select 
    format_timestamp('%Y-%m', transaction_at) as year_month,
    -- acceptance_rate = accepted payments / total payments
    round(count(case when state = 'ACCEPTED' then 1 else null end) / count(external_ref),2) as acceptance_rate

    from reporting
    group by year_month