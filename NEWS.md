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
