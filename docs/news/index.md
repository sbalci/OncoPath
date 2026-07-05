# Changelog

## OncoPath 0.0.47 (2026-07-05)

### Changes

- Declared `data.table`, `htmltools`, `psych`, and `stringr` (used via
  `::` but previously undeclared) so they install reliably with the
  module.

## OncoPath 0.0.46 (2026-07-04)

This release rolls up all changes from 0.0.33 through 0.0.46
(intermediate versions 0.0.38.1, 0.0.43, and 0.0.45). The headline
themes are a security/robustness hardening pass ahead of a
jamovi-library refactor (HTML/XSS escaping of user-supplied text and
error messages across every analysis, removal of an unreliable
variable-name mangling helper), migration of the Swimmer Plot to a
serialization-safe notices mechanism, a new suite of exported
stage-migration utility functions, new bundled example datasets, and an
upgrade of the module’s minimum jamovi app and tooling requirements.

### Security & Robustness

#### HTML/XSS Hardening (all analyses)

- **Diagnostic Test Meta-Analysis** (`diagnosticmeta`):
  - Wrapped error messages with
    [`htmltools::htmlEscape()`](https://rstudio.github.io/htmltools/reference/htmlEscape.html)
    in all five `tryCatch` handlers that write table notes: bivariate,
    HSROC, heterogeneity, meta-regression, and publication-bias analyses
  - Escaped the user-supplied meta-regression covariate label
    (`safe_covariate_label`) before it is written into the
    meta-regression results table
  - Escaped user-supplied study names in the zero-cell-correction
    warning note and HTML disclosure (`safe_studies_note`,
    `safe_studies_html`)
- **Swimmer Plot** (`swimmerplot`):
  - Escaped the best-response category in interpretation and
    manuscript-summary text
  - Escaped user-derived example values in the “Data Type Mismatch” and
    “Date Format Detected” guidance panels, and the detected date-format
    string
  - Escaped validation and analysis error messages before HTML
    interpolation
- **Treatment Response Analysis** (`waterfall`):
  - Escaped missing/available column names in the data-validation
    message
  - Escaped patient IDs lacking a baseline measurement, and the printed
    data-frame rows for invalid tumor-shrinkage and
    unusually-large-growth warnings
  - Replaced a bare `stop(plain_message)` with
    `jmvcore::reject("{}", code = NULL, plain_message)`
- **IHC Heterogeneity Analysis** (`ihcheterogeneity`):
  - Escaped the `spatial_id` variable name in the “not found in data”
    error message

#### Variable-name Handling Bug Fix

- **`diagnosticmeta`**: removed the `.escapeVar()` helper, which mangled
  column names containing spaces or punctuation
  (e.g. `Study Name (2020)` became `Study_Name_2020_`) and then used the
  mangled string as a `self$data[[...]]` key, silently returning `NULL`
  and breaking the analysis. Study/TP/FP/FN/TN variables now use their
  raw option values as lookup keys.
- **`diagnosticmeta`**: narrowed package imports from `@import mada` /
  `@import metafor` to `@importFrom mada reitsma phm` and
  `@importFrom metafor rma`, and set `dontrun: true` on the analysis
  example.

#### Output Cleanup

- Removed emoji from all HTML output panels
  (welcome/about/interpretation/glossary/plot-explanation panels, notice
  icons, and the Swimmer Plot clinical-event glyph mapping) across
  `diagnosticmeta`, `swimmerplot`, `waterfall`, and `ihcheterogeneity`,
  and replaced `%` with the word “percent” in `waterfall` and
  `ihcheterogeneity` option descriptions.

### Enhanced Existing Modules

#### Swimmer Plot (`swimmerplot`) — Notices Migration

- **NEW output** `notices` (type `Preformatted`, title “Important
  Information”) with `clearWith` on `patientID`, `startTime`, `endTime`,
  `responseVar`, `censorVar`, and `timeUnit`
- Added `.noticeList`, `.addNotice()`, and `.renderNotices()` helpers
  that render plain-text notices via the Preformatted item, avoiding
  both the
  [`jmvcore::Notice`](https://rdrr.io/pkg/jmvcore/man/Analysis.html)
  serialization error and HTML in notice content
- Re-enabled the small-sample-size `STRONG_WARNING` (n \< 10 patients),
  which was previously commented out to avoid serialization errors
- Emit an `ERROR` notice when required variables (Patient ID, Start
  Time, End Time) are missing
- Reset the notice list at the top of `.run()` to prevent accumulation
  across runs

### New Stage Migration Utility Functions

Four new R source files add an exported `stagemigration_*` helper suite
(with man pages and `STAGEMIGRATION_CONSTANTS`) supporting
staging-system comparison and validation: - **Discrimination**:
`stagemigration_calculateConcordance`,
`stagemigration_bootstrapConcordance`,
`stagemigration_competingRisksDiscrimination` - **Competing risks &
survival**: `stagemigration_competingRisksAnalysis`,
`stagemigration_calculateRMST`, `stagemigration_cutpointAnalysis` -
**Data validation & quality**: `stagemigration_validateData`,
`stagemigration_validateCovariates`,
`stagemigration_validateStagingVars`,
`stagemigration_createEventBinary`, `stagemigration_convertLabelled`,
`stagemigration_detectOutliers`, `stagemigration_dataQualityReport`,
`stagemigration_checkSampleSize` - **Safe execution & formulas**:
`stagemigration_safeAtomic`, `stagemigration_safeExecute`,
`stagemigration_buildFormula`, `stagemigration_escapeVar`

#### Shared Survival-Formula Helpers (`R/utils.R`)

- Added
  [`.asSurvivalFormula()`](https://www.serdarbalci.com/OncoPath/reference/dot-asSurvivalFormula.md),
  which wraps
  [`jmvcore::asFormula`](https://rdrr.io/pkg/jmvcore/man/asFormula.html)
  with an extended function allow-list for survival/Cox/Fine-Gray
  formula paths under jamovi 2.7.27’s hardened parser
- Added
  [`.buildSurvivalFormula()`](https://www.serdarbalci.com/OncoPath/reference/dot-buildSurvivalFormula.md),
  [`.escapeVariableNames()`](https://www.serdarbalci.com/OncoPath/reference/dot-escapeVariableNames.md),
  [`load_required_package()`](https://www.serdarbalci.com/OncoPath/reference/load_required_package.md),
  the `%notin%` / `%!in%` operators, and a `print.sensSpecTable` S3
  method

### New Example Datasets

- **NEW** `R/data.R` documents five bundled datasets:
  `diagnostic_studies`, `histopathology`, `swimmerplot_sample`,
  `waterfall_percentage_basic`, and `waterfall_raw_longitudinal`
- **NEW** `.rda` files: `diagnostic_studies` (5 studies with
  `study_name`, `tp`, `fp`, `fn`, `tn`), `swimmerplot_sample`,
  `waterfall_percentage_basic`, and `waterfall_raw_longitudinal`
- **NEW** jamovi `.omv` versions under `inst/extdata/`:
  `swimmerplot_sample.omv`, `waterfall_percentage_basic.omv`,
  `waterfall_raw_longitudinal.omv`

### Dependencies

- Added `Imports`: `cluster`, `cmprsk`, `haven`, `maxstat`, `survRM2`
  (supporting the new competing-risks, RMST, cutpoint, and labelled-data
  utilities)
- Added `Depends: R (>= 3.5.0)`

### Package Infrastructure

- Bumped version 0.0.33 → 0.0.46 (rolling up 0.0.38.1, 0.0.43, 0.0.45)
- Raised `minApp` from 1.6.0 to 2.7.27 to align with jamovi’s hardened
  `as.formula` allow-list
- Migrated roxygen configuration from `RoxygenNote: 7.3.3` to
  `Config/roxygen2/version: 8.0.0`
- De-bracketed the `BugReports` URL in DESCRIPTION
- Added module audit report
  `docs/audit/MODULE_AUDIT_REPORT_20260514-1844.md`

------------------------------------------------------------------------

## OncoPath 0.0.32.64 (2025-12-31)

### Major New Features

#### Stage Migration Analysis Tools

- **NEW**: Comprehensive suite of statistical helper functions for stage
  migration analysis
- Advanced discrimination and reclassification metrics for comparing
  staging systems
- Designed for cancer staging research and prognostic model evaluation
- Supports survival analysis with Cox proportional hazards models

#### Advanced Discrimination Metrics

- **Concordance Index (C-index)**: Paired comparison of staging system
  discrimination
- **Bootstrap Validation**: Robust C-index comparison accounting for
  data correlation
  - Configurable bootstrap replicates (default: 200)
  - Correlation-aware variance estimation for dependent staging systems
  - Automatic convergence handling and error recovery
- **Confidence Intervals**: Both analytical and bootstrap-based 95% CI
  estimation
- **Statistical Testing**: Two-sided hypothesis testing for C-index
  improvement

#### Reclassification Metrics

- **Net Reclassification Improvement (NRI)**:
  - Time-dependent NRI calculation at multiple time points
  - Separate event and non-event reclassification statistics
  - Risk category-based patient stratification (tertiles by default)
  - Variance estimation with confidence intervals and p-values
- **Integrated Discrimination Improvement (IDI)**:
  - Discrimination slope comparison between staging systems
  - Bootstrap validation option for robust inference
  - Separate discrimination for events and non-events
  - Direct probability-based assessment

#### Model Comparison Statistics

- **Information Criteria**: AIC and BIC for both staging systems with
  improvement metrics
- **Likelihood Ratio Tests**:
  - Combined model testing for incremental value
  - Individual model likelihood ratio statistics
  - Chi-square test statistics with degrees of freedom and p-values
- **Linear Trend Analysis**:
  - Wald tests for ordinal staging progression
  - Automatic handling of categorical and ordinal stage variables
  - Separate trend tests for old and new staging systems

#### Pseudo R² Measures

- **Multiple Pseudo R² Variants**:
  - **McFadden R²**: Log-likelihood ratio measure
  - **Adjusted McFadden R²**: Penalized for model complexity
  - **Cox-Snell R²**: Exponential transformation approach
  - **Nagelkerke R²**: Normalized Cox-Snell (0-1 range)
  - **Royston R²**: Placeholder for future implementation
- All measures calculated for both staging systems with improvement
  deltas
- Robust handling of edge cases (zero log-likelihoods, division by zero)

### Technical Improvements

#### Statistical Robustness

- **Correlation-Aware Variance Estimation**:
  - Spearman correlation coefficient for linear predictor correlation
  - Covariance adjustment for paired C-index comparisons
  - Conservative variance bounds (non-negative constraint)
- **Bootstrap Methods for Correlated Data**:
  - Stratified sampling preserving event/non-event ratios
  - Percentile-based confidence intervals
  - Automatic outlier detection and removal
  - Progress checkpoint callbacks for long-running analyses

#### Error Handling and Validation

- Comprehensive try-catch blocks throughout all functions
- Graceful degradation with informative error messages
- Automatic handling of:
  - Model convergence failures in bootstrap samples
  - Zero cells in contingency tables
  - Insufficient sample sizes
  - Missing or invalid data
- Validation of minimum sample requirements for reliable inference

#### Flexible Staging System Support

- **Categorical Staging**: Nominal categories without ordering
  assumptions
- **Ordinal Staging**: Ordered stages with linear trend analysis
- **Mixed Systems**: Comparison between different staging paradigms
- Automatic detection of stage levels and appropriate statistical tests
- Support for varying numbers of stages between old and new systems

### Dependencies

#### Updated Imports

- Enhanced `survival` package utilization for Cox models and concordance
- Extended `Hmisc` usage for survival correlation metrics
  (`rcorrp.cens`)
- `boot` package integration for bootstrap confidence intervals
- Comprehensive `stats` imports for statistical distributions and tests

### Internal Improvements

- Modular helper function architecture for maintainability
- Consistent naming conventions (`stagemigration_*` prefix)
- Progress callback support for computationally intensive operations
- Null coalescing operator (`%||%`) for default parameter handling
- Safe mathematical operations with bounds checking

### Use Cases

These stage migration tools are designed for: - **Cancer Research**:
Evaluating new TNM staging editions (e.g., AJCC 7th vs. 8th edition) -
**Prognostic Models**: Comparing traditional staging with molecular or
imaging-based classifiers - **Clinical Guidelines**: Evidence-based
assessment of staging system updates - **Meta-Research**: Systematic
evaluation of staging system performance across studies - **Quality
Improvement**: Hospital-level assessment of staging accuracy and
clinical impact

------------------------------------------------------------------------

## OncoPath 0.0.32 (2025-10-09)

### Documentation Improvements

#### README.Rmd

- **NEW**: Created comprehensive README.Rmd with detailed module
  description
- Enhanced feature descriptions with emojis for better readability
- Added detailed installation instructions (3 methods)
- Included quick start examples for both swimmer and waterfall plots
- Added comprehensive use cases section (Clinical Research, Pathology
  Research, Publication Support)
- Expanded acknowledgements section with gratitude to package developers
- Integrated with ClinicoPath ecosystem documentation

#### Documentation Website

- All documentation now available at:
  <https://www.serdarbalci.com/OncoPath/>
- Direct links to swimmer plot and waterfall plot guides
- Clear integration with main ClinicoPath documentation hub

#### Vignette Additions

- **NEW**: Added 9 comprehensive vignettes for enhanced documentation
- **Clinical Heatmap**: `clinicalheatmap_comprehensive.Rmd` - Clinical
  heatmap visualization
- **Digital Pathology Suite** (4 files):
  - `digital_pathology_chatgpt.md` - AI-generated pathology analysis
    guide
  - `digital_pathology_claude.md` - Comprehensive digital pathology
    documentation
  - `digital_pathology_gemini.md` - Alternative AI perspective on
    digital pathology
  - `digital-pathology-analysis-suite.md` - Complete digital pathology
    analysis overview
- **Texture Analysis**: `HARALICK_TESTING_GUIDE.md` - Haralick texture
  feature analysis testing
- **Agreement Analysis** (3 files):
  - `COMBINED_USUBUTUN_GUIDE.md` - Combined Usubutun plot guide
  - `USUBUTUN_ENHANCED_TEST_GUIDE.md` - Enhanced testing procedures
  - `USUBUTUN_TEST_GUIDE.md` - Standard testing guide for agreement
    visualization
- **Oncoplot**: `ggoncoplot_documentation.md` - Genomic alteration
  visualization documentation

#### Function Documentation

- Added waterfall plot legacy documentation: `09-waterfall-legacy.Rmd`
- Function-specific vignette: `06-function-waterfall.Rmd` - Detailed
  waterfall function guide

### Features Summary

#### Patient Follow-Up Plots

- 🏊‍♂️ **Swimmer Plot Analysis**: Timeline visualization with ggswim
  integration
- 🌊 **Waterfall Plot Analysis**: RECIST criteria treatment response
  analysis
- Complete support for clinical trial reporting and oncological research

#### Pathology Analysis Tools

- 🔬 **IHC Heterogeneity Analysis**: Immunohistochemistry marker
  analysis
- 📊 **Diagnostic Test Meta-Analysis**: Bivariate meta-analysis with
  HSROC

------------------------------------------------------------------------

## OncoPath 0.0.31.84 (2025-10-03)

### Major New Features

#### Diagnostic Test Meta-Analysis for Pathology

- **NEW**: Comprehensive diagnostic test accuracy meta-analysis module
- Bivariate random-effects meta-analysis using the Reitsma method
- Hierarchical Summary ROC (HSROC) curve analysis
- Meta-regression capabilities for exploring heterogeneity
- Publication bias assessment with funnel plots
- Support for multiple estimation methods (REML, ML, Fixed Effects,
  etc.)
- Forest plots for sensitivity and specificity
- SROC plots with confidence regions
- Designed specifically for:
  - AI/ML algorithm validation in pathology
  - Biomarker diagnostic accuracy synthesis
  - Systematic reviews of diagnostic tests

#### IHC Heterogeneity Analysis

- **NEW**: Statistical analysis of immunohistochemistry marker
  heterogeneity
- Multi-marker evaluation capabilities
- Robust statistical methods for heterogeneity assessment
- Specialized tools for pathology biomarker research

### Enhancements

#### Treatment Response Analysis (Waterfall Plot)

- Improved RECIST criteria implementation
- Enhanced visualization options
- Better handling of longitudinal data

#### Swimmer Plot

- Continued integration improvements with ggswim package
- Enhanced data validation
- Better error handling and user feedback

### Dependencies

#### New Package Dependencies

- `mada`: Meta-analysis of diagnostic accuracy studies
- `metafor`: Advanced meta-analysis and meta-regression
- `pROC`: ROC curve analysis
- `survival` & `survminer`: Survival analysis support
- `boot`: Bootstrap methods
- `dcurves`: Decision curve analysis
- `Hmisc`: Statistical utilities
- `rms`: Regression modeling strategies
- `timeROC`: Time-dependent ROC curves
- `tidyr`: Data tidying operations

### Bug Fixes

- Fixed menu organization for diagnostic meta-analysis
- Improved variable name handling with special characters
- Enhanced error messages and user guidance

### Internal Changes

- Updated NAMESPACE with new imports
- Reorganized menu structure for better discoverability
- Added comprehensive validation for meta-analysis inputs
- Improved handling of zero cells in diagnostic data

------------------------------------------------------------------------

## OncoPath 0.0.31.69 (Previous Version)

### Features

- Swimmer Plot Analysis with ggswim integration
- Waterfall Plot Analysis with RECIST criteria
- Treatment Response Visualization
- Patient Timeline Tracking

### Initial Release Features

- Comprehensive patient follow-up visualization tools
- RECIST criteria analysis
- Clinical event tracking
- Publication-ready visualizations
