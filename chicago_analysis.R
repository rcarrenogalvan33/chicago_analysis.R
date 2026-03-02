# Title: Chicago Community Hardship Analysis
# Author: rcarrenogalvan33
# Purpose: Model the non-linear relationship between income and 
#          hardship, cleaning data and applying GAMs for better fit.

# ==============================================================================
# 1. Setup and Library Loading
# ==============================================================================
library(tidyverse)
library(mgcv)  # Necessary for Generalized Additive Models (GAMs)

# ==============================================================================
# 2. Data Preparation and Cleaning
# ==============================================================================
# Generate or load data (Tribble used based on provided script)
df_demographics <- tribble(
  ~neighborhood,    ~percent_black, ~percent_immigrant,                
  "ENGLEWOOD",      95.0,           2.0,
  "AUBURN GRESHAM", 97.0,           1.5,
  "ROSELAND",       94.0,           1.2,
  "LITTLE VILLAGE", 3.0,            45.0,
  "ALBANY PARK",    4.0,            35.0,
  "BELMONT CRAGIN", 3.5,            30.0,
  "LINCOLN PARK",   4.0,            12.0,
  "LAKE VIEW",      3.5,            15.0,
  "NORTH CENTER",   2.0,            10.0
)


# Ensure neighborhood names are uppercase to match for merging.
housing_analysis <- housing_analysis %>%
  mutate(neighborhood = toupper(neighborhood))

# Merge datasets together
master_data <- left_join(housing_analysis, df_demographics, by = "neighborhood")

# Clean: Remove rows with missing data for critical demographic columns
cleaned_data <- master_data %>%
  drop_na(percent_black, percent_immigrant, hardship, income)

# ==============================================================================
# 3. Model Fitting and Diagnostics
# ==============================================================================

# --- A. Linear Model (Baseline) ---
# Formula: hardship ~ income
linear_model <- lm(hardship ~ income, data = cleaned_data)
summary(linear_model)

# --- B. Polynomial Regression (Fixing Non-Linearity) ---
# Testing a quadratic term for a curved relationship
poly_model <- lm(hardship ~ income + I(income^2), data = cleaned_data)
summary(poly_model)

# --- C. Generalized Additive Model (GAM) ---
# Automatically models the 'wiggliness' of the curve.
# k=3 limits the complexity to avoid overfitting on small data.
gam_model <- gam(hardship ~ s(income, k = 3), data = cleaned_data)
summary(gam_model)

# ==============================================================================
# 4. Visualization and Verification
# ==============================================================================

# Check GAM assumptions (residuals, qq-plot)
gam.check(gam_model)

# Plot the smooth curve learned by the GAM
plot(gam_model, 
     pages = 1, 
     shade = TRUE, 
     col = "blue", 
     main = "Non-Linear Effect of Income on Hardship",
     xlab = "Average Neighborhood Income",
     ylab = "Impact on Hardship Score")
