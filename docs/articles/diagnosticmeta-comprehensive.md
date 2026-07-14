# Diagnostic Test Meta-Analysis for Pathology

## Introduction

Diagnostic test meta-analysis is essential for synthesizing evidence
from multiple studies evaluating the accuracy of diagnostic tests in
pathology research. This module performs comprehensive meta-analysis of
diagnostic test accuracy studies, specifically designed for:

- **Immunohistochemistry (IHC) marker validation** across multiple
  studies
- **AI algorithm performance** meta-analysis  
- **Biomarker diagnostic accuracy** synthesis
- **Cross-study comparison** with heterogeneity analysis

## Why Meta-Analysis of Diagnostic Tests?

Individual diagnostic accuracy studies often have limited sample sizes
and may not be generalizable. Meta-analysis provides:

1.  **Increased Statistical Power**: Combining multiple studies
    increases precision
2.  **Robust Estimates**: More reliable pooled sensitivity and
    specificity
3.  **Heterogeneity Assessment**: Identifies variations between studies
4.  **Publication Bias Detection**: Assesses potential literature bias
5.  **Clinical Translation**: Overall evidence for implementation
    decisions

## Data Requirements

### Essential Variables

Your dataset must contain these core variables:

1.  **Study Identifier**: Unique name or ID for each study
2.  **True Positives (TP)**: Cases correctly identified as positive
3.  **False Positives (FP)**: Cases incorrectly identified as positive
4.  **False Negatives (FN)**: Cases incorrectly identified as negative  
5.  **True Negatives (TN)**: Cases correctly identified as negative

### Optional Variables for Meta-Regression

- **Patient Population**: Disease stage, demographics
- **Technical Method**: Staining protocol, automation level
- **Geographic Region**: Population-specific factors
- **Publication Year**: Temporal trends

## Example Dataset

``` r

# Example diagnostic meta-analysis dataset
diagnostic_data <- data.frame(
  study_name = c(
    "Smith_2020", "Johnson_2021", "Zhang_2019", "Mueller_2020",
    "Rodriguez_2021", "Tanaka_2020", "Brown_2019", "Lee_2021",
    "Patel_2020", "Wilson_2021"
  ),
  author = c(
    "Smith et al.", "Johnson et al.", "Zhang et al.", "Mueller et al.",
    "Rodriguez et al.", "Tanaka et al.", "Brown et al.", "Lee et al.",
    "Patel et al.", "Wilson et al."
  ),
  year = c(2020, 2021, 2019, 2020, 2021, 2020, 2019, 2021, 2020, 2021),
  true_positives = c(47, 126, 19, 36, 130, 84, 58, 91, 42, 103),
  false_positives = c(101, 272, 12, 78, 211, 68, 89, 134, 56, 142),
  false_negatives = c(9, 51, 10, 3, 19, 2, 12, 8, 7, 15),
  true_negatives = c(738, 1543, 192, 276, 959, 89, 328, 421, 237, 496),
  patient_population = c(
    "mixed", "early_stage", "advanced", "mixed", "early_stage", 
    "advanced", "mixed", "early_stage", "advanced", "mixed"
  ),
  staining_method = c(
    "automated", "manual", "automated", "manual", "automated",
    "manual", "automated", "manual", "automated", "manual"
  )
)

# Display the dataset
knitr::kable(diagnostic_data[, 1:7], 
             caption = "Example Diagnostic Test Meta-Analysis Dataset")
```

| study_name | author | year | true_positives | false_positives | false_negatives | true_negatives |
|:---|:---|---:|---:|---:|---:|---:|
| Smith_2020 | Smith et al. | 2020 | 47 | 101 | 9 | 738 |
| Johnson_2021 | Johnson et al. | 2021 | 126 | 272 | 51 | 1543 |
| Zhang_2019 | Zhang et al. | 2019 | 19 | 12 | 10 | 192 |
| Mueller_2020 | Mueller et al. | 2020 | 36 | 78 | 3 | 276 |
| Rodriguez_2021 | Rodriguez et al. | 2021 | 130 | 211 | 19 | 959 |
| Tanaka_2020 | Tanaka et al. | 2020 | 84 | 68 | 2 | 89 |
| Brown_2019 | Brown et al. | 2019 | 58 | 89 | 12 | 328 |
| Lee_2021 | Lee et al. | 2021 | 91 | 134 | 8 | 421 |
| Patel_2020 | Patel et al. | 2020 | 42 | 56 | 7 | 237 |
| Wilson_2021 | Wilson et al. | 2021 | 103 | 142 | 15 | 496 |

Example Diagnostic Test Meta-Analysis Dataset {.table}

### Data Validation

Before analysis, verify:

- ✅ No missing values in TP, FP, FN, TN columns
- ✅ All values are non-negative integers  
- ✅ Each study has complete 2×2 table data
- ✅ At least 2 studies with valid data
- ✅ Study identifiers are unique

``` r

# Calculate basic statistics for validation
diagnostic_data$sample_size <- with(diagnostic_data, 
  true_positives + false_positives + false_negatives + true_negatives)

diagnostic_data$sensitivity <- with(diagnostic_data,
  true_positives / (true_positives + false_negatives))

diagnostic_data$specificity <- with(diagnostic_data,
  true_negatives / (true_negatives + false_positives))

# Summary statistics
summary_stats <- data.frame(
  Study = diagnostic_data$study_name,
  N = diagnostic_data$sample_size,
  Sensitivity = round(diagnostic_data$sensitivity, 3),
  Specificity = round(diagnostic_data$specificity, 3)
)

knitr::kable(summary_stats, 
             caption = "Individual Study Performance Metrics")
```

| Study          |    N | Sensitivity | Specificity |
|:---------------|-----:|------------:|------------:|
| Smith_2020     |  895 |       0.839 |       0.880 |
| Johnson_2021   | 1992 |       0.712 |       0.850 |
| Zhang_2019     |  233 |       0.655 |       0.941 |
| Mueller_2020   |  393 |       0.923 |       0.780 |
| Rodriguez_2021 | 1319 |       0.872 |       0.820 |
| Tanaka_2020    |  243 |       0.977 |       0.567 |
| Brown_2019     |  487 |       0.829 |       0.787 |
| Lee_2021       |  654 |       0.919 |       0.759 |
| Patel_2020     |  342 |       0.857 |       0.809 |
| Wilson_2021    |  756 |       0.873 |       0.777 |

Individual Study Performance Metrics {.table}

## Statistical Methods

### Bivariate Random-Effects Model

The **bivariate random-effects model** (Reitsma et al.) is the gold
standard:

- Jointly analyzes sensitivity and specificity
- Accounts for correlation between measures  
- Handles threshold effects across studies
- Provides pooled estimates with confidence intervals

### Key Features:

``` r

# Conceptual framework (not executable)
# logit(sensitivity_i) ~ N(μ_sens, τ²_sens)
# logit(specificity_i) ~ N(μ_spec, τ²_spec)
# Correlation between sensitivity and specificity accounted for
```

### Holling Proportional-Hazards Summary ROC

The optional [`mada::phm()`](https://rdrr.io/pkg/mada/man/phm.html)
analysis uses the proportional-hazards relation `u^theta = p`, where `p`
is sensitivity and `u` is the false-positive rate. It reports:

- **theta**: Diagnostic accuracy parameter
- **tau-squared**: Between-study variation in diagnostic accuracy

This compact model uses adjusted profile maximum likelihood and is
distinct from the Rutter-Gatsonis HSROC threshold/accuracy
parameterization.

### Meta-Regression

Investigates heterogeneity sources:

``` r

# logit(sensitivity_i) = β₀ + β₁ × covariate_i + ε_i
# Common covariates: population, methodology, geography
```

## Using the Analysis in jamovi

### Step-by-Step Instructions

1.  **Import Data**: Load your diagnostic test dataset into jamovi

2.  **Access Function**:

    - Navigate to **Analyses → ClinicoPath → Diagnostic Test
      Meta-Analysis for Pathology**

3.  **Variable Assignment**:

    - **Study Identifier**: Select study name/ID variable
    - **True Positives**: Select TP column
    - **False Positives**: Select FP column
    - **False Negatives**: Select FN column  
    - **True Negatives**: Select TN column
    - **Covariate** (optional): Variable for meta-regression

4.  **Analysis Options**:

    - ✅ **Bivariate Random-Effects Model** (recommended)
    - ✅ **Proportional-Hazards SROC Analysis**: Holling summary ROC
      model
    - ✅ **Heterogeneity Assessment**: Study variation evaluation
    - **Meta-Regression**: Enable for covariate investigation
    - **Publication Bias**: Deeks’ funnel plot test

5.  **Visualization Options**:

    - ✅ **Forest Plot**: Study-specific sensitivity/specificity
    - ✅ **Summary ROC Plot**: Overall diagnostic performance
    - ✅ **Funnel Plot**: Publication bias assessment

## Interpreting Results

### Primary Outcomes

#### Pooled Sensitivity and Specificity

``` r

# Example results interpretation
# Pooled Sensitivity: 0.891 (95% CI: 0.808-0.941)
# Pooled Specificity: 0.780 (95% CI: 0.715-0.833)
```

**Interpretation**: - **Sensitivity (89.1%)**: Test correctly identifies
89% of diseased cases - **Specificity (78.0%)**: Test correctly
identifies 78% of non-diseased cases - **Confidence Intervals**: Range
of plausible values for true parameters

#### Diagnostic Accuracy Measures

``` r

# Example calculations for interpretation
pooled_sens <- 0.891
pooled_spec <- 0.780

# Likelihood ratios
positive_lr <- pooled_sens / (1 - pooled_spec)
negative_lr <- (1 - pooled_sens) / pooled_spec
diagnostic_or <- positive_lr / negative_lr

# Create interpretation table
measures <- data.frame(
  Measure = c("Positive Likelihood Ratio", "Negative Likelihood Ratio", 
              "Diagnostic Odds Ratio"),
  Value = c(round(positive_lr, 2), round(negative_lr, 2), 
            round(diagnostic_or, 1)),
  Interpretation = c(
    ifelse(positive_lr > 10, "Strong evidence for disease",
           ifelse(positive_lr > 5, "Moderate evidence", "Weak evidence")),
    ifelse(negative_lr < 0.1, "Strong evidence against disease",
           ifelse(negative_lr < 0.2, "Moderate evidence", "Weak evidence")),
    ifelse(diagnostic_or > 25, "Excellent discrimination",
           ifelse(diagnostic_or > 10, "Good discrimination", "Limited discrimination"))
  )
)

knitr::kable(measures, caption = "Diagnostic Accuracy Interpretation")
```

| Measure                   | Value | Interpretation           |
|:--------------------------|------:|:-------------------------|
| Positive Likelihood Ratio |  4.05 | Weak evidence            |
| Negative Likelihood Ratio |  0.14 | Moderate evidence        |
| Diagnostic Odds Ratio     | 29.00 | Excellent discrimination |

Diagnostic Accuracy Interpretation {.table}

### Heterogeneity Assessment

**I² Statistic Interpretation**: - **I² \< 25%**: Low heterogeneity -
results can be pooled reliably - **I² 25-50%**: Moderate heterogeneity -
investigate sources - **I² \> 50%**: Substantial heterogeneity - pooling
may not be appropriate

**Clinical Sources of Heterogeneity**: - Patient population differences
(disease stage, demographics) - Technical variations (antibody sources,
protocols) - Methodological differences (blinding, reference
standards) - Geographic or temporal factors

### Publication Bias

**Deeks’ Funnel Plot Test**: - **p \< 0.05**: Significant asymmetry
suggests publication bias - **p \>= 0.05**: No significant evidence of
bias

## Clinical Applications

### IHC Marker Validation

When validating immunohistochemistry markers:

``` r

# Clinical decision framework
create_clinical_table <- function(sens, spec) {
  # Calculate predictive values at different prevalences
  prevalences <- c(0.05, 0.10, 0.20, 0.30, 0.50)
  
  ppv <- sapply(prevalences, function(prev) {
    (sens * prev) / (sens * prev + (1-spec) * (1-prev))
  })
  
  npv <- sapply(prevalences, function(prev) {
    (spec * (1-prev)) / ((1-sens) * prev + spec * (1-prev))
  })
  
  data.frame(
    Prevalence = paste0(prevalences * 100, "%"),
    PPV = paste0(round(ppv * 100, 1), "%"),
    NPV = paste0(round(npv * 100, 1), "%")
  )
}

# Example with pooled estimates
clinical_table <- create_clinical_table(0.891, 0.780)
knitr::kable(clinical_table, 
             caption = "Predictive Values at Different Disease Prevalences")
```

| Prevalence | PPV   | NPV   |
|:-----------|:------|:------|
| 5%         | 17.6% | 99.3% |
| 10%        | 31%   | 98.5% |
| 20%        | 50.3% | 96.6% |
| 30%        | 63.4% | 94.3% |
| 50%        | 80.2% | 87.7% |

Predictive Values at Different Disease Prevalences {.table}

**Key Clinical Insights**: - **High Sensitivity (89%)**: Suitable for
screening applications - **Moderate Specificity (78%)**: Positive
results may need confirmation - **Prevalence Dependency**: Predictive
values vary significantly with disease prevalence

### AI Algorithm Meta-Analysis

Special considerations for AI/ML algorithms:

1.  **Dataset Diversity**: Heterogeneity reflects generalizability
2.  **Technical Specifications**: Algorithm versions, preprocessing
3.  **Validation Approach**: Cross-validation vs. external validation
4.  **Performance Stability**: Prediction intervals indicate reliability

## Advanced Interpretation

### Meta-Regression Results

When investigating covariates:

``` r

# Example meta-regression results
# Sensitivity ~ Patient Population
# Advanced vs. Mixed: β = -0.45, p = 0.02
# Interpretation: Advanced stage patients show 45% lower logit-sensitivity
```

**Clinical Translation**: - Significant covariates explain heterogeneity
sources - Adjust expectations based on population characteristics -
Consider population-specific validation

### Quality Assessment

Use **QUADAS-2** framework: 1. **Patient Selection**: Representative
population? 2. **Index Test**: Blinded interpretation? 3. **Reference
Standard**: Appropriate gold standard? 4. **Flow and Timing**: Complete
verification?

## Troubleshooting Common Issues

### Data Problems

**Zero Cells**: Some studies have TP=0, FP=0, FN=0, or TN=0 -
**Solution**: Analysis applies continuity correction automatically

**Extreme Values**: Studies with 100% sensitivity/specificity -
**Check**: Are values realistic for the clinical context? - **Action**:
Consider sensitivity analysis excluding extreme studies

### Interpretation Challenges

**High Heterogeneity** (I² \> 75%): - **Action**: Consider subgroup
analysis instead of pooling - **Investigate**: Sources through
meta-regression

**Publication Bias Detected**: - **Implication**: Results may be
overestimated - **Action**: Search for unpublished studies, sensitivity
analysis

## Sample Results Interpretation

### Complete Example Output

``` r

# Sample results summary
results_summary <- "
Bivariate Meta-Analysis Results (n=10 studies, N=5,513 patients):
- Pooled Sensitivity: 89.1% (95% CI: 80.8%-94.1%)
- Pooled Specificity: 78.0% (95% CI: 71.5%-83.3%)
- Positive Likelihood Ratio: 4.05
- Negative Likelihood Ratio: 0.14
- Diagnostic Odds Ratio: 29.0

Heterogeneity Assessment:
- Sensitivity I²: 68% (substantial heterogeneity)
- Specificity I²: 45% (moderate heterogeneity)

Publication Bias:
- Deeks' test p-value: 0.23 (no significant bias)
"

cat(results_summary)
#> 
#> Bivariate Meta-Analysis Results (n=10 studies, N=5,513 patients):
#> - Pooled Sensitivity: 89.1% (95% CI: 80.8%-94.1%)
#> - Pooled Specificity: 78.0% (95% CI: 71.5%-83.3%)
#> - Positive Likelihood Ratio: 4.05
#> - Negative Likelihood Ratio: 0.14
#> - Diagnostic Odds Ratio: 29.0
#> 
#> Heterogeneity Assessment:
#> - Sensitivity I²: 68% (substantial heterogeneity)
#> - Specificity I²: 45% (moderate heterogeneity)
#> 
#> Publication Bias:
#> - Deeks' test p-value: 0.23 (no significant bias)
```

### Clinical Translation

> **Summary**: The pooled analysis shows the IHC marker has good
> diagnostic performance with 89% sensitivity and 78% specificity. A
> positive test increases disease odds ~4-fold, while a negative test
> reduces odds by ~86%. Substantial heterogeneity in sensitivity
> suggests performance varies by population or methodology. No
> significant publication bias was detected.

**Recommendations**: 1. **High sensitivity**: Suitable for screening
applications 2. **Moderate specificity**: Positive results may need
confirmation 3. **Strong negative LR**: Negative results effectively
rule out disease 4. **Investigate heterogeneity**: Consider
population-specific validation

## Best Practices

### Planning Your Meta-Analysis

1.  **Define Research Question**:
    - **Population**: Target patient population
    - **Index Test**: Diagnostic test of interest
    - **Reference Standard**: Gold standard comparator
    - **Outcomes**: Sensitivity, specificity, likelihood ratios
2.  **Literature Search Strategy**:
    - Multiple databases (PubMed, Embase, Cochrane)
    - Comprehensive search terms and filters
    - Reference screening and author contact
3.  **Data Extraction**:
    - Standardized forms and double extraction
    - 2×2 table reconstruction when needed

### Reporting Standards

Follow **PRISMA-DTA** guidelines: - ✅ Structured abstract with key
results - ✅ Study selection flow diagram  
- ✅ Included studies characteristics table - ✅ Forest plots for
sensitivity and specificity - ✅ Summary ROC plot with confidence
region - ✅ Heterogeneity assessment and exploration - ✅ Publication
bias assessment - ✅ Clinical implications discussion

## Conclusion

Diagnostic test meta-analysis provides robust evidence synthesis for
clinical decision-making. Key takeaways:

1.  **Use bivariate models** for sensitivity and specificity analysis
2.  **Investigate heterogeneity** through meta-regression and subgroups
3.  **Assess publication bias** for unbiased estimates  
4.  **Consider clinical context** when interpreting pooled results
5.  **Follow reporting guidelines** for transparent communication

The ClinicoPath implementation follows current methodological standards
and provides comprehensive analysis capabilities for pathology research
applications.

## References

1.  Reitsma JB, et al. Bivariate analysis of sensitivity and specificity
    produces informative summary measures in diagnostic reviews. *J Clin
    Epidemiol*. 2005;58(10):982-990.

2.  Rutter CM, Gatsonis CA. A hierarchical regression approach to
    meta-analysis of diagnostic test accuracy evaluations. *Stat Med*.
    2001;20(19):2865-2884.

3.  Deeks JJ, et al. The performance of tests of publication bias and
    other sample size effects in systematic reviews of diagnostic test
    accuracy. *J Clin Epidemiol*. 2005;58(9):882-893.

4.  Whiting PF, et al. QUADAS-2: a revised tool for quality assessment
    of diagnostic accuracy studies. *Ann Intern Med*.
    2011;155(8):529-536.

5.  McInnes MDF, et al. Preferred Reporting Items for Systematic Review
    and Meta-analysis of Diagnostic Test Accuracy Studies: PRISMA-DTA
    Statement. *JAMA*. 2018;319(4):388-396.
