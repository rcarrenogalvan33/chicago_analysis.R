# chicago_analysis.R
# Chicago Hardship & Income Analysis

## Project Overview
This analysis explores the relationship between neighborhood per capita income and the "Hardship Index" across Chicago community areas. The goal was to determine if a simple linear model accurately describes the data or if more complex, non-linear modeling is required.



## Data Sources
* **Socioeconomic Data:** Sourced directly from the [Chicago Data Portal](https://data.cityofchicago.org/) (ACS 5-year estimates).
* **Demographic Subset:** A targeted lookup table for 9 representative neighborhoods (Englewood, Lake View, Albany Park, etc.) used to demonstrate data joining and modeling workflows.

## Analytical Approach
1. **Data Cleaning:** Utilized `tidyverse` for renaming columns, handling missing values, and normalizing neighborhood names for relational joins.
2. **Linear Regression:** Established a baseline model ($Hardship = \beta_0 + \beta_1 \cdot Income$).
3. **Polynomial Regression:** Introduced a quadratic term to account for the "curve" in the data.
4. **Generalized Additive Models (GAMs):** Implemented `mgcv::gam()` with a basis dimension of `k=3`. This allowed for a flexible, smooth fit that better represents the sharp decrease in hardship as income rises out of the lowest brackets.



## Key Findings
* The relationship between income and hardship is **strongly non-linear**.
* Standard linear models over-predict hardship at middle-income levels.
* The GAM provided the highest Adjusted R-squared (0.944), explaining 95.9% of the deviance in the sample.

## Requirements
To run the script `chicago_analysis.R`, you will need:
* R (version 4.0+)
* `tidyverse`
* `mgcv`
