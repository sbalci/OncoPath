# OncoPath 0.0.32.64 (2025-12-31)

## Major New Features

### Stage Migration Analysis Tools
- **NEW**: Comprehensive suite of statistical helper functions for stage migration analysis
- Advanced discrimination and reclassification metrics for comparing staging systems
- Designed for cancer staging research and prognostic model evaluation
- Supports survival analysis with Cox proportional hazards models

### Advanced Discrimination Metrics
- **Concordance Index (C-index)**: Paired comparison of staging system discrimination
- **Bootstrap Validation**: Robust C-index comparison accounting for data correlation
  - Configurable bootstrap replicates (default: 200)
  - Correlation-aware variance estimation for dependent staging systems
  - Automatic convergence handling and error recovery
- **Confidence Intervals**: Both analytical and bootstrap-based 95% CI estimation
- **Statistical Testing**: Two-sided hypothesis testing for C-index improvement

### Reclassification Metrics
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

### Model Comparison Statistics
- **Information Criteria**: AIC and BIC for both staging systems with improvement metrics
- **Likelihood Ratio Tests**:
  - Combined model testing for incremental value
  - Individual model likelihood ratio statistics
  - Chi-square test statistics with degrees of freedom and p-values
- **Linear Trend Analysis**:
  - Wald tests for ordinal staging progression
  - Automatic handling of categorical and ordinal stage variables
  - Separate trend tests for old and new staging systems

### Pseudo R² Measures
- **Multiple Pseudo R² Variants**:
  - **McFadden R²**: Log-likelihood ratio measure
  - **Adjusted McFadden R²**: Penalized for model complexity
  - **Cox-Snell R²**: Exponential transformation approach
  - **Nagelkerke R²**: Normalized Cox-Snell (0-1 range)
  - **Royston R²**: Placeholder for future implementation
- All measures calculated for both staging systems with improvement deltas
- Robust handling of edge cases (zero log-likelihoods, division by zero)

## Technical Improvements

### Statistical Robustness
- **Correlation-Aware Variance Estimation**:
  - Spearman correlation coefficient for linear predictor correlation
  - Covariance adjustment for paired C-index comparisons
  - Conservative variance bounds (non-negative constraint)
- **Bootstrap Methods for Correlated Data**:
  - Stratified sampling preserving event/non-event ratios
  - Percentile-based confidence intervals
  - Automatic outlier detection and removal
  - Progress checkpoint callbacks for long-running analyses

### Error Handling and Validation
- Comprehensive try-catch blocks throughout all functions
- Graceful degradation with informative error messages
- Automatic handling of:
  - Model convergence failures in bootstrap samples
  - Zero cells in contingency tables
  - Insufficient sample sizes
  - Missing or invalid data
- Validation of minimum sample requirements for reliable inference

### Flexible Staging System Support
- **Categorical Staging**: Nominal categories without ordering assumptions
- **Ordinal Staging**: Ordered stages with linear trend analysis
- **Mixed Systems**: Comparison between different staging paradigms
- Automatic detection of stage levels and appropriate statistical tests
- Support for varying numbers of stages between old and new systems

## Dependencies

### Updated Imports
- Enhanced `survival` package utilization for Cox models and concordance
- Extended `Hmisc` usage for survival correlation metrics (`rcorrp.cens`)
- `boot` package integration for bootstrap confidence intervals
- Comprehensive `stats` imports for statistical distributions and tests

## Internal Improvements
- Modular helper function architecture for maintainability
- Consistent naming conventions (`stagemigration_*` prefix)
- Progress callback support for computationally intensive operations
- Null coalescing operator (`%||%`) for default parameter handling
- Safe mathematical operations with bounds checking

## Use Cases

These stage migration tools are designed for:
- **Cancer Research**: Evaluating new TNM staging editions (e.g., AJCC 7th vs. 8th edition)
- **Prognostic Models**: Comparing traditional staging with molecular or imaging-based classifiers
- **Clinical Guidelines**: Evidence-based assessment of staging system updates
- **Meta-Research**: Systematic evaluation of staging system performance across studies
- **Quality Improvement**: Hospital-level assessment of staging accuracy and clinical impact

---

# OncoPath 0.0.32 (2025-10-09)

## Documentation Improvements

### README.Rmd
- **NEW**: Created comprehensive README.Rmd with detailed module description
- Enhanced feature descriptions with emojis for better readability
- Added detailed installation instructions (3 methods)
- Included quick start examples for both swimmer and waterfall plots
- Added comprehensive use cases section (Clinical Research, Pathology Research, Publication Support)
- Expanded acknowledgements section with gratitude to package developers
- Integrated with ClinicoPath ecosystem documentation

### Documentation Website
- All documentation now available at: https://www.serdarbalci.com/OncoPath/
- Direct links to swimmer plot and waterfall plot guides
- Clear integration with main ClinicoPath documentation hub

### Vignette Additions
- **NEW**: Added 9 comprehensive vignettes for enhanced documentation
- **Clinical Heatmap**: `clinicalheatmap_comprehensive.Rmd` - Clinical heatmap visualization
- **Digital Pathology Suite** (4 files):
  - `digital_pathology_chatgpt.md` - AI-generated pathology analysis guide
  - `digital_pathology_claude.md` - Comprehensive digital pathology documentation
  - `digital_pathology_gemini.md` - Alternative AI perspective on digital pathology
  - `digital-pathology-analysis-suite.md` - Complete digital pathology analysis overview
- **Texture Analysis**: `HARALICK_TESTING_GUIDE.md` - Haralick texture feature analysis testing
- **Agreement Analysis** (3 files):
  - `COMBINED_USUBUTUN_GUIDE.md` - Combined Usubutun plot guide
  - `USUBUTUN_ENHANCED_TEST_GUIDE.md` - Enhanced testing procedures
  - `USUBUTUN_TEST_GUIDE.md` - Standard testing guide for agreement visualization
- **Oncoplot**: `ggoncoplot_documentation.md` - Genomic alteration visualization documentation

### Function Documentation
- Added waterfall plot legacy documentation: `09-waterfall-legacy.Rmd`
- Function-specific vignette: `06-function-waterfall.Rmd` - Detailed waterfall function guide

## Features Summary

### Patient Follow-Up Plots
- 🏊‍♂️ **Swimmer Plot Analysis**: Timeline visualization with ggswim integration
- 🌊 **Waterfall Plot Analysis**: RECIST criteria treatment response analysis
- Complete support for clinical trial reporting and oncological research

### Pathology Analysis Tools
- 🔬 **IHC Heterogeneity Analysis**: Immunohistochemistry marker analysis
- 📊 **Diagnostic Test Meta-Analysis**: Bivariate meta-analysis with HSROC

---

# OncoPath 0.0.31.84 (2025-10-03)

## Major New Features

### Diagnostic Test Meta-Analysis for Pathology
- **NEW**: Comprehensive diagnostic test accuracy meta-analysis module
- Bivariate random-effects meta-analysis using the Reitsma method
- Hierarchical Summary ROC (HSROC) curve analysis
- Meta-regression capabilities for exploring heterogeneity
- Publication bias assessment with funnel plots
- Support for multiple estimation methods (REML, ML, Fixed Effects, etc.)
- Forest plots for sensitivity and specificity
- SROC plots with confidence regions
- Designed specifically for:
  - AI/ML algorithm validation in pathology
  - Biomarker diagnostic accuracy synthesis
  - Systematic reviews of diagnostic tests

### IHC Heterogeneity Analysis
- **NEW**: Statistical analysis of immunohistochemistry marker heterogeneity
- Multi-marker evaluation capabilities
- Robust statistical methods for heterogeneity assessment
- Specialized tools for pathology biomarker research

## Enhancements

### Treatment Response Analysis (Waterfall Plot)
- Improved RECIST criteria implementation
- Enhanced visualization options
- Better handling of longitudinal data

### Swimmer Plot
- Continued integration improvements with ggswim package
- Enhanced data validation
- Better error handling and user feedback

## Dependencies

### New Package Dependencies
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

## Bug Fixes
- Fixed menu organization for diagnostic meta-analysis
- Improved variable name handling with special characters
- Enhanced error messages and user guidance

## Internal Changes
- Updated NAMESPACE with new imports
- Reorganized menu structure for better discoverability
- Added comprehensive validation for meta-analysis inputs
- Improved handling of zero cells in diagnostic data

---

# OncoPath 0.0.31.69 (Previous Version)

## Features
- Swimmer Plot Analysis with ggswim integration
- Waterfall Plot Analysis with RECIST criteria
- Treatment Response Visualization
- Patient Timeline Tracking

## Initial Release Features
- Comprehensive patient follow-up visualization tools
- RECIST criteria analysis
- Clinical event tracking
- Publication-ready visualizations
