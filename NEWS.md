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
