# Heart Disease Exploratory Data Analysis Using R

## Project Overview

This project presents an exploratory and statistical analysis of the UCI Heart Disease dataset (Processed Cleveland subset) using R.

The objective is to investigate associations between selected demographic and clinical characteristics and recorded heart disease status through descriptive statistics, exploratory data analysis, and statistical testing.

## Dataset

**Source:** [UCI Machine Learning Repository – Heart Disease](https://archive.ics.uci.edu/dataset/45/heart+disease)

- **Observations:** 303
- **Original variables:** 14
- **Outcome:** Binary heart disease status derived from the original diagnosis variable (`num`)
- **Missing values:** Identified and handled where appropriate

## Tools and Methods

**Programming Language:** R

**Libraries:** tidyverse, ggplot2, effectsize

**Analytical Methods:**
- Data cleaning and preprocessing
- Exploratory data analysis (EDA)
- Descriptive statistics
- Welch's two-sample t-tests
- Cohen's d effect size estimation
- Data visualization using ggplot2

## Key Findings

### 1. Age

Participants with heart disease were older on average than those without heart disease (56.6 vs. 52.6 years).

### 2. Maximum Heart Rate

Participants with heart disease had a lower mean maximum heart rate than those without heart disease (139 vs. 158 bpm).

The estimated mean difference was 19 bpm (95% CI: 14.3–23.9), with strong statistical evidence of a group difference (Welch's t-test, p < 0.001).

The standardized effect was large (Cohen's d = 0.92, 95% CI: 0.68–1.15).

### 3. Cholesterol

Mean cholesterol was slightly higher among participants with heart disease (251 vs. 243 mg/dL).

However, the difference was not statistically significant at the 0.05 level (Welch's t-test, p = 0.10), and the standardized effect was small (Cohen's d = −0.17, 95% CI: −0.40–0.06).

### 4. ST Depression (Oldpeak)

Mean oldpeak was higher among participants with heart disease (1.57 vs. 0.59).

### 5. Exercise-Induced Angina

Exercise-induced angina was observed in 54.7% of participants with heart disease compared with 14.0% of participants without heart disease.

## Limitations

This analysis is observational and exploratory. The findings describe associations rather than causal relationships.

Group comparisons are unadjusted for potential confounding factors. The analysis does not establish clinical predictive performance, and no predictive model was developed.

The findings should not be interpreted as clinical diagnostic recommendations.

## Reproducibility

1. Install R and the required packages (`tidyverse` and `effectsize`).
2. Download the Processed Cleveland dataset from the UCI Machine Learning Repository.
3. Place the dataset at `data/processed.cleveland.data`.
4. Open the project folder in RStudio.
5. Run `R/heart_disease_analysis.R` from the project root directory.

The analysis generates descriptive statistics and statistical test results. Summary statistics are exported to `results/summary_statistics.csv`.

## Skills Demonstrated

- R programming and data manipulation
- Clinical data exploration
- Data cleaning and preprocessing
- Statistical hypothesis testing
- Confidence interval interpretation
- Effect size estimation
- Scientific reporting and reproducible analysis

## Data Attribution

UCI Machine Learning Repository, Heart Disease dataset. Licensed under CC BY 4.0.
