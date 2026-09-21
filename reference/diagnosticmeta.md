# Diagnostic Test Meta-Analysis for Pathology

Comprehensive meta-analysis of diagnostic test accuracy studies designed
for pathology research. Performs bivariate random-effects modeling,
proportional-hazards SROC analysis, meta-regression, and publication
bias assessment for AI algorithm validation and biomarker diagnostic
accuracy synthesis.

## Usage

``` r
diagnosticmeta(
  data,
  study = NULL,
  true_positives = NULL,
  false_positives = NULL,
  false_negatives = NULL,
  true_negatives = NULL,
  covariate = NULL,
  bivariate_analysis = TRUE,
  hsroc_analysis = FALSE,
  meta_regression = FALSE,
  heterogeneity_analysis = FALSE,
  publication_bias = FALSE,
  confidence_level = 95,
  method = "reml",
  zero_cell_correction = "none",
  forest_plot = FALSE,
  sroc_plot = FALSE,
  funnel_plot = FALSE,
  show_individual_studies = FALSE,
  show_interpretation = FALSE,
  show_methodology = FALSE,
  show_analysis_summary = FALSE,
  color_palette = "standard",
  show_plot_explanations = FALSE
)
```

## Arguments

- data:

  the data as a data frame

- study:

  Variable containing unique study identifiers

- true_positives:

  Number of true positive results in each study

- false_positives:

  Number of false positive results in each study

- false_negatives:

  Number of false negative results in each study

- true_negatives:

  Number of true negative results in each study

- covariate:

  Optional covariate for meta-regression analysis

- bivariate_analysis:

  Perform bivariate random-effects meta-analysis

- hsroc_analysis:

  Perform Holling proportional-hazards summary ROC analysis

- meta_regression:

  Perform meta-regression with specified covariate

- heterogeneity_analysis:

  Perform heterogeneity analysis including I-squared and Q statistics

- publication_bias:

  Assess publication bias using Deeks' funnel plot test

- confidence_level:

  Confidence level for all intervals: the pooled estimates and
  likelihood ratios, the prediction interval for a future study, the
  per-study Wilson intervals, and the confidence and prediction regions
  on the SROC plot.

- method:

  Estimator for the between-study variance. REML is recommended. The
  bivariate model uses this method directly; the univariate
  heterogeneity and meta-regression models map it to the metafor
  equivalent, so 'Method of Moments' gives DerSimonian-Laird and
  'Variance components' gives the Hedges estimator in those two tables.
  'Method of Moments' is the multivariate extension of DerSimonian-Laird
  (via mvmeta), so choosing it gives a DerSimonian-Laird-type estimator
  in the bivariate model as well; REML is preferred for diagnostic
  accuracy data because the moment estimators are non-iterative and
  truncate negative variance components to zero.

- zero_cell_correction:

  Method for handling zero cells in 2x2 tables. 'none' (recommended)
  applies no correction to the data itself; the bivariate model still
  adds 0.5 to studies with a zero cell at fitting time (mada's 'single'
  correction), while the univariate heterogeneity and meta-regression
  models exclude those studies instead, so they rest on fewer studies.
  Both are disclosed in the output. Under 'none' the publication-bias
  path behaves differently from the rest: because a zero cell survives
  to that point, Deeks' test and the funnel plot add 0.5 to EVERY study,
  not only the affected ones (correcting only the affected studies would
  build a size-related trend into the test's own outcome variable), and
  no asymmetry verdict is reported at all when more than a quarter of
  the studies have a zero cell. The other three settings leave no zero
  cell, so neither of those steps applies and a verdict is always given.
  'constant' adds 0.5 to all four cells of affected studies before any
  analysis. 'zero_cells' adds 0.5 only to the zero cells themselves.
  'reciprocal_n' adds 1/N to all cells of affected studies, where N is
  the study's total sample size. (The former option keys 'treatment_arm'
  and 'empirical' were renamed: they did not implement the procedures
  those names denote in Sweeting et al. 2004.)

- forest_plot:

  Generate forest plot for sensitivity and specificity

- sroc_plot:

  Generate summary receiver operating characteristic plot

- funnel_plot:

  Generate funnel plot for publication bias assessment

- show_individual_studies:

  Display results for individual studies in summary tables

- show_interpretation:

  Display clinical interpretation guidelines and recommendations

- show_methodology:

  Display detailed methodology and statistical approach information

- show_analysis_summary:

  Display natural language summary of analysis results

- color_palette:

  Color palette for all plots - choose color-blind safe options for
  accessibility

- show_plot_explanations:

  Display detailed explanations for all plots including interpretation
  guidance

## Value

A results object containing:

|                                  |     |     |     |     |          |
|----------------------------------|-----|-----|-----|-----|----------|
| `results$instructions`           |     |     |     |     | a html   |
| `results$notices`                |     |     |     |     | a html   |
| `results$summary`                |     |     |     |     | a html   |
| `results$about`                  |     |     |     |     | a html   |
| `results$bivariateresults`       |     |     |     |     | a table  |
| `results$hsrocresults`           |     |     |     |     | a table  |
| `results$heterogeneity`          |     |     |     |     | a table  |
| `results$metaregression`         |     |     |     |     | a table  |
| `results$publicationbias`        |     |     |     |     | a table  |
| `results$individualstudies`      |     |     |     |     | a table  |
| `results$forestplot`             |     |     |     |     | an image |
| `results$srocplot`               |     |     |     |     | an image |
| `results$funnelplot`             |     |     |     |     | an image |
| `results$interpretation`         |     |     |     |     | a html   |
| `results$forestplot_explanation` |     |     |     |     | a html   |
| `results$srocplot_explanation`   |     |     |     |     | a html   |
| `results$funnelplot_explanation` |     |     |     |     | a html   |

Tables can be converted to data frames with `asDF` or
[`as.data.frame`](https://rdrr.io/r/base/as.data.frame.html). For
example:

`results$bivariateresults$asDF`

`as.data.frame(results$bivariateresults)`
