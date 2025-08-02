-- Custom table creation to handle large financial values
-- Resolved integer overflow issues for billion-dollar assets
DROP TABLE IF EXISTS retierment."SCFP2022";


CREATE TABLE retierment."SCFP2022" (
    yy1 integer NULL,
    y1 integer NULL,
    wgt real NULL,
    hhsex integer NULL,  -- Gender coding: 1=Male, 2=Female
    age integer NULL,
    agecl integer NULL,
    educ integer NULL,
    edcl integer NULL,
    married integer NULL,
    kids integer NULL,
    -- Financial variables requiring BIGINT for large values
    income BIGINT NULL,          -- Household income
    retqliq BIGINT NULL,         -- Retirement liquid assets  
    houses BIGINT NULL,          -- Home values
    networth BIGINT NULL,        -- Total net worth
    asset BIGINT NULL,           -- Total assets
    kghouse BIGINT NULL,         -- Real estate capital gains
    kgstmf BIGINT NULL,          -- Investment capital gains
    kgtotal BIGINT NULL,         -- Total capital gains
    norminc BIGINT NULL,         -- Normal income
    penacctwd BIGINT NULL,       -- Pension account withdrawals
    kginc BIGINT NULL,           -- Capital gains income
    -- Standard integer fields
    stocks integer NULL,         -- Stock ownership (0/1)
    bond integer NULL,           -- Bond ownership (0/1)
    -- ... other standard fields
);


-- Data quality validation
SELECT 
    COUNT(*) as total_records,
    COUNT(hhsex) as gender_not_null,
    COUNT(income) as income_not_null,
    COUNT(retqliq) as retirement_not_null,
    COUNT(*) - COUNT(hhsex) as missing_gender,
    COUNT(*) - COUNT(age) as missing_age,
    COUNT(*) - COUNT(income) as missing_income,
    COUNT(*) - COUNT(retqliq) as missing_retirement
FROM retierment."SCFP2022";


-- Verify large financial values imported correctly
SELECT 
    MAX(income) as max_income,
    MAX(networth) as max_networth,
    MAX(retqliq) as max_retirement,
    MAX(houses) as max_house_value,
    MAX(asset) as max_assets
FROM retierment."SCFP2022";


-- Create clean analysis dataset with readable column names
CREATE TABLE retierment.retirement_analysis AS
SELECT 
    hhsex as gender_code,
    CASE WHEN hhsex = 1 THEN 'Male-headed' ELSE 'Female-headed' END as gender,
    age,
    CASE 
        WHEN age < 35 THEN 'Under 35'
        WHEN age < 50 THEN '35-49' 
        WHEN age < 65 THEN '50-64'
        ELSE '65+'
    END as age_group,
    income as household_income,
    retqliq as retirement_savings,
    CASE WHEN stocks > 0 THEN 1 ELSE 0 END as owns_stocks,
    houses as home_value,
    networth as net_worth
FROM retierment."SCFP2022"
WHERE hhsex IS NOT NULL;  -- Remove any records with missing gender
