-- Retirement wealth ratio: Years of income saved
-- This created the "years of income saved" metric showing 4.0 vs 1.2 years
CREATE OR REPLACE VIEW retirement_wealth_ratios AS
SELECT 
    gender,
    age_group,
    household_income,
    retirement_savings,
    CASE 
        WHEN household_income > 10000 THEN retirement_savings / household_income 
        ELSE NULL 
    END as retirement_wealth_ratio
FROM retierment.retirement_analysis
WHERE household_income > 10000;  -- Filter out unrealistic income values


-- Summary statistics for retirement wealth ratios
SELECT 
    gender,
    age_group,
    COUNT(*) as households,
    ROUND(AVG(retirement_wealth_ratio), 1) as avg_years_income_saved,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY retirement_wealth_ratio), 1) as median_years_saved,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY retirement_wealth_ratio), 1) as p95_years_saved
FROM retirement_wealth_ratios
GROUP BY gender, age_group
ORDER BY gender, age_group;


-- Gap analysis: Calculate ratios between male and female metrics
WITH gender_stats AS (
    SELECT 
        age_group,
        AVG(CASE WHEN gender = 'Male-headed' THEN retirement_savings END) as male_avg_retirement,
        AVG(CASE WHEN gender = 'Female-headed' THEN retirement_savings END) as female_avg_retirement,
        AVG(CASE WHEN gender = 'Male-headed' THEN household_income END) as male_avg_income,
        AVG(CASE WHEN gender = 'Female-headed' THEN household_income END) as female_avg_income,
        AVG(CASE WHEN gender = 'Male-headed' AND owns_stocks = 1 THEN 1.0 ELSE 0.0 END) as male_stock_rate,
        AVG(CASE WHEN gender = 'Female-headed' AND owns_stocks = 1 THEN 1.0 ELSE 0.0 END) as female_stock_rate
    FROM retierment.retirement_analysis
    GROUP BY age_group
)
SELECT 
    age_group,
    ROUND(male_avg_retirement / NULLIF(female_avg_retirement, 0), 1) as retirement_gap_ratio,
    ROUND(male_avg_income / NULLIF(female_avg_income, 0), 1) as income_gap_ratio,
    ROUND(male_stock_rate / NULLIF(female_stock_rate, 0), 1) as stock_participation_gap_ratio
FROM gender_stats
ORDER BY age_group;


-- Investment depth analysis among stock owners only
SELECT 
    gender,
    age_group,
    COUNT(*) as stock_owners,
    ROUND(AVG(retirement_savings), 0) as avg_retirement_among_investors,
    ROUND(AVG(household_income), 0) as avg_income_among_investors
FROM retierment.retirement_analysis
WHERE owns_stocks = 1
GROUP BY gender, age_group
ORDER BY gender, age_group;


-- Market opportunity sizing
SELECT 
    'Female-headed households' as target_market,
    COUNT(*) as household_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retierment.retirement_analysis), 1) as market_percentage,
    ROUND(AVG(retirement_savings), 0) as avg_current_savings,
    ROUND((SELECT AVG(retirement_savings) FROM retierment.retirement_analysis WHERE gender = 'Male-headed') - 
          AVG(retirement_savings), 0) as savings_gap_per_household
FROM retierment.retirement_analysis
WHERE gender = 'Female-headed';