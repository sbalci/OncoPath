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
- ✅ At least 3 studies with valid data
- ✅ Study identifiers are unique, one 2×2 table per independent study

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

The **bivariate random-effects model** (Reitsma et al.) is the
recommended model for pooling sensitivity and specificity:

- Jointly analyzes sensitivity and specificity
- Accounts for the between-study correlation between them
- Gives a summary ROC curve; when studies use different positivity
  thresholds, read the curve and the prediction region rather than the
  single pooled point
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

## Running It From R

The call below uses the bundled `diagnosticmeta_test_categorical`
dataset (20 synthetic studies, the same data as the jamovi example) and
shows the numbers OncoPath 1.1.0 returns for it.

``` r

library(OncoPath)
data(diagnosticmeta_test_categorical, package = "OncoPath")
head(diagnosticmeta_test_categorical, 3)
#>     study true_positives false_positives false_negatives true_negatives year quality_score imaging_modality
#> 1 Study_1             81              10              30            153 2015             5               CT
#> 2 Study_2             56               6               6            120 2019             7       Ultrasound
#> 3 Study_3             84               4              11            100 2015             7               CT

res <- diagnosticmeta(
  data            = diagnosticmeta_test_categorical,
  study           = "study",
  true_positives  = "true_positives",
  false_positives = "false_positives",
  false_negatives = "false_negatives",
  true_negatives  = "true_negatives",
  covariate       = "imaging_modality",   # CT 5, MRI 9, ultrasound 6 studies

  bivariate_analysis      = TRUE,   # Reitsma bivariate random-effects model
  hsroc_analysis          = TRUE,   # Holling proportional-hazards SROC
  heterogeneity_analysis  = TRUE,   # Q, I-squared, tau-squared
  meta_regression         = TRUE,   # needs `covariate`
  publication_bias        = TRUE,   # Deeks' funnel plot asymmetry test
  confidence_level        = 95,     # PERCENT, 50-99. Not 0.95 - that is rejected.
  zero_cell_correction    = "none", # none | constant | zero_cells | reciprocal_n
  forest_plot             = TRUE,
  sroc_plot               = TRUE
)
```

Two argument details are easy to get wrong and both raise an error
rather than silently misbehaving:

- **`confidence_level` is a percentage on a 50-99 scale.** Passing the
  more usual `0.95` fails.
- **`zero_cell_correction` accepts `none`, `constant`, `zero_cells` and
  `reciprocal_n`.** Under the default `none` every model adds 0.5 to all
  four cells of a study with a zero cell when it is fitted, so every
  model uses every study. The former keys `treatment_arm` and
  `empirical` were renamed and are rejected. Deeks’ test always uses the
  raw counts, whatever this setting.

### What Comes Back

    bivariateresults
                     parameter estimate ci_lower ci_upper
            Pooled Sensitivity    81.67    76.63    85.83
            Pooled Specificity    89.19    85.73    91.90
     Positive Likelihood Ratio     7.56     5.60    10.21
     Negative Likelihood Ratio     0.21     0.16     0.27
         Diagnostic Odds Ratio    36.77    22.59    59.85

    hsrocresults (proportional-hazards SROC)
                                  parameter estimate std_error z_value p_value
      Diagnostic accuracy parameter (theta)   0.0897    0.0163  -56.00  <0.001
             Between-study variance (tau^2)   0.0027    0.0018
                                        AUC   0.918     0.014

    heterogeneity
         measure q_statistic df  p_value i_squared tau_squared
     Sensitivity       88.37 19   <0.001      79.1        0.36
     Specificity       95.33 19   <0.001      81.0        0.39

    publicationbias
                                  test statistic p_value interpretation
     Deeks' Funnel Plot Asymmetry Test    -0.49    0.63 No asymmetry detected (p >= 0.05)

The theta test is against theta = 1, the value at which the SROC curve
is the chance diagonal, so a large negative z means accuracy well above
chance. It does not test a clinical threshold.

Read these together rather than in isolation. Heterogeneity is
substantial (I-squared about 80% for both measures), and the analysis
warns that the 95% prediction interval for a new study is wide
(sensitivity 55%-94%, specificity 68%-97%). The pooled pair is therefore
an average over studies that differ more than sampling error explains;
the SROC curve and the prediction region describe this body of evidence
better than the pooled point. A non-significant Deeks’ test is not
evidence of absent publication bias.

### Meta-Regression

`meta_regression = TRUE` requires a `covariate` column naming a
study-level characteristic. With `imaging_modality` the model estimates
two contrasts (MRI and ultrasound against CT) for each of sensitivity
and specificity, on the logit scale:

                  parameter estimate    SE p_value
    Sensitivity   Intercept     1.62  0.32  <0.001
                  MRI          -0.04  0.41   0.93
                  Ultrasound   -0.32  0.45   0.48
    Specificity   Intercept     2.54  0.32  <0.001
                  MRI          -0.40  0.40   0.33
                  Ultrasound   -0.84  0.42   0.059

No contrast reaches p \< 0.05. Twenty studies for two parameters is the
minimum the Cochrane DTA Handbook suggests (about ten studies per
covariate parameter), so treat a meta-regression of this size as
exploratory: it can suggest a source of heterogeneity, not establish
one.

### Presentation Options

`forest_plot`, `sroc_plot` and `funnel_plot` control the three figures;
`color_palette` sets their color scheme and `show_plot_explanations`
adds a note under each explaining how to read it.
`show_individual_studies` adds the per-study sensitivity and specificity
table, which is worth keeping — a pooled estimate without the studies
behind it is hard to sanity-check.

## Using the Analysis in jamovi

### Step-by-Step Instructions

1.  **Import Data**: Load your diagnostic test dataset into jamovi

2.  **Access Function**:

    - Navigate to **Analyses → OncoPath → Meta-Analysis → Diagnostic
      Test Meta-Analysis for Pathology**

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

# Pooled estimates for diagnostic_data above (bivariate model, REML)
# Pooled Sensitivity: 85.8% (95% CI: 78.0%-91.1%)
# Pooled Specificity: 80.8% (95% CI: 74.7%-85.8%)
```

**Interpretation**: - **Sensitivity (85.8%)**: Test correctly identifies
about 86 of every 100 diseased cases - **Specificity (80.8%)**: Test
correctly identifies about 81 of every 100 non-diseased cases -
**Confidence Intervals**: Range of plausible values for true parameters

#### Diagnostic Accuracy Measures

``` r

# Example calculations for interpretation
pooled_sens <- 0.858
pooled_spec <- 0.808

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
| Positive Likelihood Ratio |  4.47 | Weak evidence            |
| Negative Likelihood Ratio |  0.18 | Moderate evidence        |
| Diagnostic Odds Ratio     | 25.40 | Excellent discrimination |

Diagnostic Accuracy Interpretation {.table}

### Heterogeneity Assessment

**I² Statistic Interpretation** (Higgins’ conventional bands, borrowed
from intervention reviews): - **I² \< 25%**: Little heterogeneity on
that margin. With few studies I² is imprecise, and on its own it does
not show that pooling is appropriate - **I² 25-50%**: Moderate
heterogeneity - investigate sources - **I² \> 50%**: Substantial
heterogeneity - expected whenever studies use different positivity
thresholds; read the SROC curve and the prediction region rather than
the pooled point

The analysis reports I² separately for sensitivity and for specificity.
Neither describes the bivariate model; the prediction interval does.

**Clinical Sources of Heterogeneity**: - Patient population differences
(disease stage, demographics) - Technical variations (antibody sources,
protocols) - Methodological differences (blinding, reference
standards) - Geographic or temporal factors

### Publication Bias

**Deeks’ Funnel Plot Test**: - **p \< 0.05**: The funnel plot is
asymmetric. Publication bias is one explanation; heterogeneity, a
threshold effect and a real relation between study size and accuracy are
others, and the test cannot tell them apart - **p \>= 0.05**: No
asymmetry detected. With fewer than 10 studies the test has little
power, so this does not show that publication bias is absent

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
clinical_table <- create_clinical_table(0.858, 0.808)
knitr::kable(clinical_table, 
             caption = "Predictive Values at Different Disease Prevalences")
```

| Prevalence | PPV   | NPV   |
|:-----------|:------|:------|
| 5%         | 19%   | 99.1% |
| 10%        | 33.2% | 98.1% |
| 20%        | 52.8% | 95.8% |
| 30%        | 65.7% | 93%   |
| 50%        | 81.7% | 85.1% |

Predictive Values at Different Disease Prevalences {.table}

**Key Clinical Insights**: - **Sensitivity (86%) and specificity (81%)**
describe the test, not its fitness for a role. Whether it suits
screening or confirmation depends on the prevalence in the population
you test and on what a missed case or a false positive costs -
**Prevalence Dependency**: Predictive values vary markedly with disease
prevalence - **Heterogeneity**: with a wide prediction interval,
predictive values in your own setting can differ markedly from the table
above

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
# Interpretation: β is a difference in logit sensitivity, so the odds of a
# positive result in diseased patients are exp(-0.45) = 0.64 times those in
# the mixed population - about 36% lower ODDS, not 45% lower sensitivity
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

**Funnel Asymmetry Detected**: - **Implication**: Small and large
studies report different accuracy; if publication bias is the cause, the
pooled results may be overestimated - **Action**: Look for a clinical
explanation first, then search for unpublished studies

## Sample Results Interpretation

### Complete Example Output

``` r

# Sample results summary
results_summary <- "
Bivariate Meta-Analysis Results (n=10 studies, N=7,314 participants):
- Pooled Sensitivity: 85.8% (95% CI: 78.0%-91.1%)
- Pooled Specificity: 80.8% (95% CI: 74.7%-85.8%)
- Positive Likelihood Ratio: 4.48 (3.56-5.63)
- Negative Likelihood Ratio: 0.18 (0.12-0.26)
- Diagnostic Odds Ratio: 25.5 (18.9-34.3)
- 95% prediction interval for a new study: sensitivity 47.2%-97.6%,
  specificity 51.9%-94.3%

Heterogeneity Assessment (univariate, per margin):
- Sensitivity I²: 78.8%
- Specificity I²: 96.7%

Publication Bias:
- Deeks' test: t = 1.71, p = 0.13 (no asymmetry detected; 10 studies give
  the test little power)
"

cat(results_summary)
#> 
#> Bivariate Meta-Analysis Results (n=10 studies, N=7,314 participants):
#> - Pooled Sensitivity: 85.8% (95% CI: 78.0%-91.1%)
#> - Pooled Specificity: 80.8% (95% CI: 74.7%-85.8%)
#> - Positive Likelihood Ratio: 4.48 (3.56-5.63)
#> - Negative Likelihood Ratio: 0.18 (0.12-0.26)
#> - Diagnostic Odds Ratio: 25.5 (18.9-34.3)
#> - 95% prediction interval for a new study: sensitivity 47.2%-97.6%,
#>   specificity 51.9%-94.3%
#> 
#> Heterogeneity Assessment (univariate, per margin):
#> - Sensitivity I²: 78.8%
#> - Specificity I²: 96.7%
#> 
#> Publication Bias:
#> - Deeks' test: t = 1.71, p = 0.13 (no asymmetry detected; 10 studies give
#>   the test little power)
```

### Clinical Translation

> **Summary**: Across 10 studies the IHC marker has a pooled sensitivity
> of 85.8% and specificity of 80.8%. A positive result multiplies the
> pre-test odds of disease by about 4.5 (weak evidence on the
> conventional 2-5-10 scale), and a negative result multiplies them by
> about 0.18 (moderate evidence against disease). Heterogeneity is
> substantial: a new laboratory could see a sensitivity anywhere from
> about 47% to 98% and a specificity from about 52% to 94%. Deeks’ test
> found no funnel asymmetry, but with 10 studies that does not rule out
> publication bias.

**Recommendations**: 1. **Report the prediction interval with the pooled
pair**: it, not the pooled point, says what a new setting can expect 2.
**Negative LR of 0.18 is moderate, not strong**: a negative result
lowers the probability of disease but does not rule it out on its own 3.
**Choose the role from the clinical context**: screening or confirmation
depends on prevalence and on the cost of each kind of error, which the
meta-analysis does not know 4. **Investigate heterogeneity**: patient
spectrum, staining protocol and thresholds, with meta-regression if
there are enough studies

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

The pooled estimates are only as good as the studies behind them: assess
each study’s risk of bias (QUADAS-2) and report the review following
PRISMA-DTA.

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
