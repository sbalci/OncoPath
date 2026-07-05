# Package index

## Main Analysis Functions

Core functions for oncological and pathological research

- [`swimmerplot()`](https://www.serdarbalci.com/OncoPath/reference/swimmerplot.md)
  : Swimmer Plot
- [`swimmerplotClass`](https://www.serdarbalci.com/OncoPath/reference/swimmerplotClass.md)
  : Swimmer Plot
- [`waterfall()`](https://www.serdarbalci.com/OncoPath/reference/waterfall.md)
  : Treatment Response Analysis
- [`waterfallClass`](https://www.serdarbalci.com/OncoPath/reference/waterfallClass.md)
  : Treatment Response Analysis (Waterfall) Class
- [`diagnosticmeta()`](https://www.serdarbalci.com/OncoPath/reference/diagnosticmeta.md)
  : Diagnostic Test Meta-Analysis for Pathology
- [`diagnosticmetaClass`](https://www.serdarbalci.com/OncoPath/reference/diagnosticmetaClass.md)
  : Diagnostic Test Meta-Analysis for Pathology
- [`ihcheterogeneity()`](https://www.serdarbalci.com/OncoPath/reference/ihcheterogeneity.md)
  : IHC Heterogeneity Analysis

## Diagnostic Test Functions

Functions for diagnostic test accuracy analysis

- [`calculate_sensitivity()`](https://www.serdarbalci.com/OncoPath/reference/calculate_sensitivity.md)
  : Calculate test sensitivity
- [`calculate_specificity()`](https://www.serdarbalci.com/OncoPath/reference/calculate_specificity.md)
  : Calculate test specificity
- [`calculate_ppv()`](https://www.serdarbalci.com/OncoPath/reference/calculate_ppv.md)
  : Calculate positive predictive value (PPV)
- [`calculate_npv()`](https://www.serdarbalci.com/OncoPath/reference/calculate_npv.md)
  : Calculate negative predictive value (NPV)
- [`calculate_plr()`](https://www.serdarbalci.com/OncoPath/reference/calculate_plr.md)
  : Calculate positive likelihood ratio
- [`calculate_nlr()`](https://www.serdarbalci.com/OncoPath/reference/calculate_nlr.md)
  : Calculate negative likelihood ratio
- [`calculate_auc()`](https://www.serdarbalci.com/OncoPath/reference/calculate_auc.md)
  : Approximate AUC from sensitivity and specificity
- [`validateROCInputs()`](https://www.serdarbalci.com/OncoPath/reference/validateROCInputs.md)
  : Validate inputs for ROC analysis
- [`bootstrapIDI()`](https://www.serdarbalci.com/OncoPath/reference/bootstrapIDI.md)
  : Bootstrap IDI calculation with confidence intervals

## IHC Analysis Functions

Immunohistochemistry marker analysis utilities

- [`validateIHCData()`](https://www.serdarbalci.com/OncoPath/reference/validateIHCData.md)
  : Validate IHC Data Requirements
- [`validateIHCClustering()`](https://www.serdarbalci.com/OncoPath/reference/validateIHCClustering.md)
  : Validate IHC Clustering Parameters
- [`convertIHCToNumeric()`](https://www.serdarbalci.com/OncoPath/reference/convertIHCToNumeric.md)
  : Convert IHC Marker Data to Numeric Matrix
- [`convertIHCMarkerToNumeric()`](https://www.serdarbalci.com/OncoPath/reference/convertIHCMarkerToNumeric.md)
  : Convert IHC Marker Data Types Safely
- [`calculateIHCMarkerSummary()`](https://www.serdarbalci.com/OncoPath/reference/calculateIHCMarkerSummary.md)
  : Calculate IHC Marker Summary Statistics
- [`calculateHScore()`](https://www.serdarbalci.com/OncoPath/reference/calculateHScore.md)
  : Calculate H-Score from Intensity and Proportion
- [`calculateIHCDistance()`](https://www.serdarbalci.com/OncoPath/reference/calculateIHCDistance.md)
  : Calculate Distance Matrix for IHC Data
- [`calculateIHCSilhouette()`](https://www.serdarbalci.com/OncoPath/reference/calculateIHCSilhouette.md)
  : Calculate Silhouette Analysis for Clustering Quality
- [`showIHCDataRequirements()`](https://www.serdarbalci.com/OncoPath/reference/showIHCDataRequirements.md)
  : Generate IHC Data Requirements HTML

## IHC Visualization Functions

Functions for IHC visualization and theming

- [`getIHCTheme()`](https://www.serdarbalci.com/OncoPath/reference/getIHCTheme.md)
  : Get Professional IHC Visualization Theme
- [`getIHCColorPalette()`](https://www.serdarbalci.com/OncoPath/reference/getIHCColorPalette.md)
  : Get Professional Color Palette for IHC Visualizations
- [`formatIHCPValue()`](https://www.serdarbalci.com/OncoPath/reference/formatIHCPValue.md)
  : Format P-values Consistently for IHC Reports
- [`getIHCSignificanceStars()`](https://www.serdarbalci.com/OncoPath/reference/getIHCSignificanceStars.md)
  : Get Significance Stars for P-values

## Utility Functions

Helper functions for data processing

- [`safe_divide()`](https://www.serdarbalci.com/OncoPath/reference/safe_divide.md)
  : Safe division function
- [`prop_to_percent()`](https://www.serdarbalci.com/OncoPath/reference/prop_to_percent.md)
  : Convert proportion to percentage string
- [`raw_to_prob()`](https://www.serdarbalci.com/OncoPath/reference/raw_to_prob.md)
  : Convert raw test values to predicted probabilities using ROC curve
- [`is_in_range()`](https://www.serdarbalci.com/OncoPath/reference/is_in_range.md)
  : Check if value is within valid range
- [`load_required_package()`](https://www.serdarbalci.com/OncoPath/reference/load_required_package.md)
  : Check whether a required package is available
- [`` `%>%` ``](https://www.serdarbalci.com/OncoPath/reference/pipe.md)
  : Pipe operator

## HTML Utilities

HTML output utilities

- [`print(`*`<sensSpecTable>`*`)`](https://www.serdarbalci.com/OncoPath/reference/print.sensSpecTable.md)
  : Format HTML table for sensitivity/specificity results

## Datasets

Bundled example datasets

- [`diagnostic_studies`](https://www.serdarbalci.com/OncoPath/reference/diagnostic_studies.md)
  : Diagnostic Studies Sample Dataset
- [`histopathology`](https://www.serdarbalci.com/OncoPath/reference/histopathology.md)
  : Histopathology Sample Dataset
- [`swimmerplot_sample`](https://www.serdarbalci.com/OncoPath/reference/swimmerplot_sample.md)
  : Swimmer Plot Sample Dataset
- [`waterfall_percentage_basic`](https://www.serdarbalci.com/OncoPath/reference/waterfall_percentage_basic.md)
  : Waterfall Plot Percentage Basic Dataset
- [`waterfall_raw_longitudinal`](https://www.serdarbalci.com/OncoPath/reference/waterfall_raw_longitudinal.md)
  : Waterfall Plot Raw Longitudinal Dataset

## Package Information

Package startup and information

- [`clinicopath_startup_message()`](https://www.serdarbalci.com/OncoPath/reference/clinicopath_startup_message.md)
  : Package startup message
