# IHC Heterogeneity Analysis

Quantifies how well regional IHC measurements (biopsies, cores, fields)
represent a case. With a reference measurement (whole section, hotspot
or overall score) it reports the Spearman correlation of each region
with the reference, the absolute-agreement ICC(2,1), the per-case
coefficient of variation, and, for each region, the mean difference from
the reference with its 95 percent CI and Bland-Altman limits of
agreement. Without a reference it compares the regions with one another.
Each difference is judged against a margin set by the user (bias_margin,
default 5 percent of the comparison mean): ruled out when its 90 percent
CI lies inside the margin (two one-sided tests), shown to be material
when a Bonferroni-adjusted CI lies entirely beyond it, and inconclusive
otherwise. Optional variance components, sample-size planning for ICC
precision (Bonett 2002) and comparisons between spatial compartments.

## Usage

``` r
ihcheterogeneity(
  data,
  wholesection = NULL,
  biopsy1 = NULL,
  biopsy2 = NULL,
  biopsy3 = NULL,
  biopsy4 = NULL,
  biopsies = NULL,
  spatial_id = NULL,
  compareCompartments = FALSE,
  compartmentTests = FALSE,
  analysis_type = "comprehensive",
  sampling_strategy = "unknown",
  cv_threshold = 20,
  correlation_threshold = 0.8,
  bias_margin = 5,
  show_variability_plots = FALSE,
  variance_components = FALSE,
  sample_size_planning = FALSE,
  generate_recommendations = FALSE,
  showSummary = FALSE,
  showGlossary = FALSE,
  showReportSentences = FALSE,
  showAssumptions = FALSE
)
```

## Arguments

- data:

  the data as a data frame

- wholesection:

  Optional reference measurement for comparison with regional
  measurements. Can be whole section average, hotspot area, or overall
  tumor measurement. Leave empty for inter-regional comparison studies.
  Example: Ki67 proliferation index (0-100 percent), ER H-score (0-300),
  PR percentage (0-100 percent).

- biopsy1:

  Continuous biomarker measurement from first tissue region or area.
  Should represent same biomarker as reference measurement for
  heterogeneity comparison. Example: Ki67 percent from tumor periphery,
  ER H-score from invasive front.

- biopsy2:

  Second tissue region biomarker measurement for heterogeneity analysis

- biopsy3:

  Third tissue region biomarker measurement

- biopsy4:

  Fourth tissue region biomarker measurement

- biopsies:

  Further regional measurements, any number, analysed like Regional
  Measurements 1 to 4.

- spatial_id:

  The compartment each case was sampled from (e.g., Central/Invasive,
  Preinvasive/Invasive): one row per case, one compartment per case.
  Data with one row per case and compartment count each case once per
  row, as if they were different patients, which overstates the sample
  and narrows every interval. Compartments are listed in the level order
  of the variable; cases without an identifier are left out of the
  compartment tables. In R, convert a haven-labelled code column with
  haven::as_factor() first, or the codes are shown instead of the
  labels.

- compareCompartments:

  Compares the ICC, the within-case CV and, when a reference is
  supplied, the mean bias between spatial compartments. Requires the
  Spatial Region ID variable; compartments need at least 3 cases.

- compartmentTests:

  Tests whether heterogeneity differs between compartments:
  Kruskal-Wallis test on the per-case CV (is one compartment more
  heterogeneous?), Brown-Forsythe test on the spread of per-case CVs,
  and Kruskal-Wallis test on the per-case mean biomarker level.
  Compartments need at least 3 cases.

- analysis_type:

  Primary focus of the heterogeneity analysis. (The former 'bias' level
  was merged into 'reproducibility': the two were computationally
  identical - the bias table is always computed when a reference is
  supplied.)

- sampling_strategy:

  How the regions were chosen. Recorded for reporting only: it changes
  no computation, and systematic or stratified sampling adds a note on
  how to read the estimates.

- cv_threshold:

  Largest acceptable within-case coefficient of variation (the root mean
  square of the per-case CVs), in percent. The CV is graded low at or
  below half of this value, moderate up to it and high above it. Choose
  it for your marker and scoring method before looking at the results.

- correlation_threshold:

  Smallest acceptable Spearman correlation. With a reference, the mean
  correlation of the regions with the reference is graded, unless a
  region is shown to fall below the threshold (its upper 95 percent
  limit below it), in which case that region is graded; without a
  reference, the mean correlation between regions is graded. Choose it
  before looking at the results.

- bias_margin:

  Largest systematic difference, as a percentage of the comparison mean
  (the reference, or the other regions), that is still clinically
  acceptable. A difference is ruled out when its 90 percent CI lies
  inside the margin (two one-sided tests), and shown to be material when
  a Bonferroni-adjusted CI lies entirely beyond it; otherwise it is
  inconclusive. A difference shown to change with the level
  (proportional bias) is also judged at the 5th and 95th percentiles of
  the level, and is ruled out only when both ends lie inside the margin.
  Choose it before looking at the results.

- show_variability_plots:

  Show the regional-measurement, per-case CV and spatial plots. They are
  always shown under the Variance and Comprehensive focuses
  (Comprehensive is the default), so this option adds them under the
  Reproducibility focus.

- variance_components:

  Two-way random-effects decomposition into between-case, within-case
  and method variance. Always shown under the Variance and Comprehensive
  focuses (Comprehensive is the default), so this option adds it under
  the Reproducibility focus.

- sample_size_planning:

  Number of cases needed to estimate the ICC with a 95 percent CI of
  width 0.20 or 0.10 (Bonett 2002), at planning ICCs of 0.75 and 0.90
  and at the observed ICC, for the number of measurements per case in
  this analysis. Always shown under the Comprehensive focus.

- generate_recommendations:

  Recommendations on regions per case, calibration of systematic
  differences and quality control, derived from the results of this
  analysis.

- showSummary:

  Display natural-language summary of heterogeneity analysis results

- showGlossary:

  Display definitions of statistical terms (ICC, CV, correlation)

- showReportSentences:

  Display pre-formatted sentences ready for clinical reports and
  publications

- showAssumptions:

  Display analysis assumptions, data requirements, and methodological
  considerations

## Value

A results object containing:

|  |  |  |  |  |  |
|----|----|----|----|----|----|
| `results$welcome` |  |  |  |  | Welcome screen shown when no variables selected |
| `results$notices` |  |  |  |  | a html |
| `results$interpretation` |  |  |  |  | a html |
| `results$report_sentences` |  |  |  |  | Pre-formatted sentences ready for clinical reports and publications |
| `results$assumptions` |  |  |  |  | Analysis assumptions, data requirements, and methodological considerations |
| `results$summary` |  |  |  |  | Natural-language summary of heterogeneity analysis results |
| `results$glossary` |  |  |  |  | Definitions of key statistical terms used in the analysis |
| `results$reproducibilitytable` |  |  |  |  | Correlation and reliability metrics |
| `results$samplingbiastable` |  |  |  |  | Systematic bias assessment between methods |
| `results$variancetable` |  |  |  |  | Sources of measurement variability |
| `results$samplesizetable` |  |  |  |  | Cases needed to estimate the ICC with a chosen 95 percent CI width (Bonett 2002) |
| `results$spatialanalysistable` |  |  |  |  | Variability across spatial regions |
| `results$compartmentComparison` |  |  |  |  | Statistical comparison of heterogeneity metrics between compartments |
| `results$compartmentTests` |  |  |  |  | Formal statistical tests comparing heterogeneity across compartments |
| `results$biopsyplot` |  |  |  |  | Distribution comparison across regional measurements and reference (if provided) |
| `results$variabilityplot` |  |  |  |  | Coefficient of variation by case |
| `results$spatialplot` |  |  |  |  | Spatial distribution of biomarker values |

Tables can be converted to data frames with `asDF` or
[`as.data.frame`](https://rdrr.io/r/base/as.data.frame.html). For
example:

`results$reproducibilitytable$asDF`

`as.data.frame(results$reproducibilitytable)`

## Examples

``` r
if (FALSE) { # \dontrun{
data('ihcheterogeneity_test', package = 'OncoPath')

# Three regional Ki67 scores against the whole-section score
ihcheterogeneity(
    data = ihcheterogeneity_test,
    wholesection = 'wholesection',
    biopsy1 = 'biopsy1',
    biopsy2 = 'biopsy2',
    biopsy3 = 'biopsy3',
    bias_margin = 5)
} # }
```
