
### Welcome to my repo!
This is Luis de la Riva's assignment for the Data Analyst - Finance role at Deel. 

Methodology includes:

* Cleaning data in Power Query to clean the Acceptance CSV
* Creating a dbt project that prepares our data for reporting

### Difficulties
* The acceptance report had different delimiters (; for all columns and , for rates) and some weird quotation around rates. I used Power Query to normalise this data.
* The external_ref values starting with - were mistakenly labelled by Excel as formulas, resulting in #NAME! errors that hid the actual value. 
    I found and replaced '=' in those values that Excel was converting to formulas.

### Staging
Arrange the rates JSON so that it can be used to determine USD payments starting from any currency

### Intermediate


### Reporting