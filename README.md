
# Welcome to my repo!
This is Luis de la Riva's assignment for the Data Analyst - Finance role at Deel. 

Methodology includes:

* Cleaning data in Power Query to clean the Acceptance CSV
* Creating a dbt project that prepares our data for reporting

# Comments
* The acceptance report had different delimiters (';' for all columns and ',' for rates) and too many quotations around rates. I used Power Query to normalise this data.
* The external_ref values starting with - were mistakenly labelled by Excel as formulas, resulting in #NAME! errors that hid the actual value. 
    I found and replaced '=' in those values that Excel was converting to formulas.
* The payment provider is called GlobePay on some files and GlobalPay on others.

# Assumptions
* I am doing more transformations in staging than I would normally do in a dbt project, but I thought handling the rates issue ASAP would clarify 
* I am assuming it is important to follow dbt's best practices; hence I am adding tests, a macro to avoid repeating SQL code and in-code comments.

# Task 0: dbt project

## Staging
Arrange the rates JSON so that it can be used to determine USD payments starting from any currency

## Intermediate
Takes the most complex transformations e.g., splits USD amounts by accepted vs declined

## Reporting
The model that is synced with Looker Studio

# Task 1 - Report of declining payment rate
The most complex logic (a macro to determine the exchange rate, the USD calculations, etc.) are done inside dbt.
The rpt table is shown in Looker, where we add the acceptance rate as a calculated field. 
        count(
            case
                when state = 'ACCEPTED' then 1
                else null
            end
        ) / count(external_ref)

The dashboard explains the potential reasons for this decline.