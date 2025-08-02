# Data Sources

## Primary Dataset
- **Source:** Federal Reserve Survey of Consumer Finances (SCF) 2022
- **URL:** https://www.federalreserve.gov/econres/scfindex.htm
- **Sample Size:** 22,975 households (nationally representative)
- **File Used:** Summary Extract Public Data
- **Last Updated:** April 3, 2024

## Key Variables Used
- `HHSEX`: Household head gender (1=Male, 2=Female)
- `RETQLIQ`: Retirement liquid assets (in dollars)
- `INCOME`: Total household income (in dollars)
- `STOCKS`: Stock ownership indicator (0=No, 1=Yes)
- `AGE`: Age of household head
- `NETWORTH`: Total household net worth (in dollars)

## Data Quality
- **Missing Values:** Zero missing values in critical analysis variables
- **Data Validation:** Confirmed through SQL quality checks
- **Financial Values:** Required BIGINT data types for billion-dollar amounts

## Data Access
Original data freely available from Federal Reserve website. This analysis used cleaned and processed version focusing on retirement readiness metrics.
