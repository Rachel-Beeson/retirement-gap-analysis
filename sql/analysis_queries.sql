-- Basic demographic breakdown that revealed the 6X gap
SELECT 
    hhsex,
    COUNT(*) as households,
    ROUND(AVG(age), 1) as avg_age,
    ROUND(AVG(income/1000000.0), 2) as avg_income_millions,
    ROUND(AVG(retqliq/1000000.0), 2) as avg_retirement_millions
FROM retierment."SCFP2022"
GROUP BY hhsex
ORDER BY hhsex;


-- Age group analysis showing gap progression over lifecycle
SELECT 
    hhsex,
    CASE 
        WHEN age < 35 THEN 'Under 35'
        WHEN age < 50 THEN '35-49' 
        WHEN age < 65 THEN '50-64'
        ELSE '65+'
    END as age_group,
    COUNT(*) as households,
    ROUND(AVG(income/1000000.0), 2) as avg_income_millions,
    ROUND(AVG(retqliq/1000000.0), 2) as avg_retirement_millions
FROM retierment."SCFP2022"
GROUP BY hhsex, age_group
ORDER BY hhsex, age_group;


-- Stock ownership participation rates by demographics
SELECT 
    hhsex,
    CASE 
        WHEN age < 35 THEN 'Under 35'
        WHEN age < 50 THEN '35-49' 
        WHEN age < 65 THEN '50-64'
        ELSE '65+'
    END as age_group,
    COUNT(*) as total_households,
    SUM(CASE WHEN stocks > 0 THEN 1 ELSE 0 END) as stock_owners,
    ROUND(100.0 * SUM(CASE WHEN stocks > 0 THEN 1 ELSE 0 END) / COUNT(*), 1) as stock_ownership_pct
FROM retierment."SCFP2022"
GROUP BY hhsex, age_group
ORDER BY hhsex, age_group;


-- Analysis of stock owners only - investment depth gap
SELECT 
    hhsex,
    CASE 
        WHEN age < 35 THEN 'Under 35'
        WHEN age < 50 THEN '35-49' 
        WHEN age < 65 THEN '50-64'
        ELSE '65+'
    END as age_group,
    COUNT(*) as stock_owning_households,
    ROUND(AVG(retqliq/1000.0), 0) as avg_retirement_savings_k
FROM retierment."SCFP2022"
WHERE stocks > 0  -- Only households that own stocks
GROUP BY hhsex, age_group
ORDER BY hhsex, age_group;


-- Income distribution analysis for scatter plot insights
SELECT 
    gender,
    age_group,
    household_income,
    retirement_savings,
    net_worth,
    owns_stocks
FROM retierment.retirement_analysis
ORDER BY household_income DESC;


-- Gender comparison with clean labels for visualization
SELECT 
    gender,
    COUNT(*) as total_households,
    AVG(household_income) as avg_income,
    AVG(retirement_savings) as avg_retirement_savings,
    AVG(CASE WHEN owns_stocks = 1 THEN 1.0 ELSE 0.0 END) as stock_participation_rate
FROM retierment.retirement_analysis
GROUP BY gender;