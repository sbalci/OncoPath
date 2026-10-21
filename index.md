# OncoPath

**Oncology and pathology analyses for jamovi and R**

[![Project Status:
Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![GitHub
release](https://img.shields.io/github/release/sbalci/OncoPath.svg)](https://github.com/sbalci/OncoPath/releases/)
[![GitHub
issues](https://img.shields.io/github/issues/sbalci/OncoPath.svg)](https://github.com/sbalci/OncoPath/issues)
[![jamovi
Module](https://img.shields.io/badge/jamovi-module-brightgreen.svg?logo=jamovi)](https://www.jamovi.org/)
[![Documentation](https://img.shields.io/badge/docs-pkgdown-blue.svg)](https://www.serdarbalci.com/OncoPath/)

------------------------------------------------------------------------

## Overview

**OncoPath** is a [jamovi](https://www.jamovi.org) module and R package
for oncology and pathology research. It is one of the modules of the
[ClinicoPath](https://github.com/sbalci/ClinicoPathJamoviModule) project
and adds four analyses under the **OncoPath** menu in jamovi: patient
timelines, tumour burden response, diagnostic test accuracy
meta-analysis, and regional heterogeneity of an immunohistochemistry
(IHC) marker.

The results are for research and exploratory description. They are not a
substitute for a protocol-specified trial analysis or for clinical
judgement.

------------------------------------------------------------------------

## Analyses (4)

| Analysis (jamovi menu) | R function | Menu subgroup | What it does |
|:---|:---|:---|:---|
| **Swimmer Plot** | `swimmerplot` | Patient Follow-Up Plots | One lane per patient from start and end times (numbers or dates), coloured by response; optional censoring status, up to five milestones, event markers and a grouping variable. Reports ORR and DCR with exact CIs, median follow-up (reverse Kaplan-Meier when a censoring status is given) and person-time by best response. |
| **Treatment Response: Patient-Level Burden** | `waterfall` | Patient Follow-Up Plots | Waterfall and spider plots from one tumour burden value per patient (a percent change) or per visit (a raw measurement). Assigns CR/PR/SD/PD with thresholds adapted from RECIST v1.1, measures progression against the nadir, and reports ORR and DCR with exact CIs, group comparisons, time to response and duration of response. |
| **Diagnostic Test Meta-Analysis for Pathology** | `diagnosticmeta` | Meta-Analysis | Pools 2x2 tables (TP, FP, FN, TN) from independent studies: bivariate random-effects model (Reitsma), proportional-hazards SROC model (Holling), heterogeneity, meta-regression on one study-level covariate, Deeks’ funnel-plot test, and forest, SROC and funnel plots. |
| **IHC Heterogeneity Analysis** | `ihcheterogeneity` | IHC Analysis | For one continuous IHC measurement (for example percent positive cells or an H-score) taken in several regions of the same case: how well regions (biopsies, cores, fields) agree with a reference measurement or with one another. Spearman correlation, ICC(2,1) and ICC(3,1), per-case CV, Bland-Altman limits of agreement, equivalence-margin judgements, and optional variance components, sample-size planning and spatial-compartment comparisons. |

### What the analyses do not do

- **Treatment Response** is not a RECIST v1.1 implementation. It never
  sees individual lesions, so it cannot sum target lesions, detect a new
  lesion, judge non-target progression or confirm a response. Its
  categories and ORR/DCR are unconfirmed and exploratory.
- **Swimmer Plot** reads the response categories you supply. It shows
  ORR and DCR only when every response value is a RECIST category (CR,
  PR, SD, PD or NE).
- **IHC Heterogeneity** analyses one marker at a time and measures
  regional (sampling) variability within each case. It does not measure
  agreement between observers.
- **Diagnostic Test Meta-Analysis** expects one 2x2 table per
  independent study. Several readers, cut-offs or algorithms applied to
  the same cohort are not independent studies.

------------------------------------------------------------------------

## Installation

### In jamovi

OncoPath needs jamovi 2.7.27 or later.

- When OncoPath is listed in the jamovi library: **Modules** (top right)
  → **jamovi library** → search for **OncoPath** → **Install**.
- Until then, a module file (`.jmo`) can be side-loaded through
  **Modules** → **jamovi library** → **Sideload**, when one is attached
  to a [GitHub release](https://github.com/sbalci/OncoPath/releases/).

### As an R package

``` r

# install.packages("remotes")
remotes::install_github("sbalci/OncoPath")
```

------------------------------------------------------------------------

## Quick Start (R)

Each function takes a data frame and column names as strings.

``` r

library(OncoPath)

# 1. Swimmer plot: patient timelines with response
data("swimmerplot_sample", package = "OncoPath")
swim <- swimmerplot(
  data        = swimmerplot_sample,
  patientID   = "PatientID",
  startTime   = "StartTime",
  endTime     = "EndTime",
  responseVar = "Response"
)

# 2. Treatment response from percent change (one row per patient)
data("waterfall_percentage_basic", package = "OncoPath")
wf <- waterfall(
  data        = waterfall_percentage_basic,
  patientID   = "PatientID",
  responseVar = "Response",
  inputType   = "percentage",
  groupVar    = "Treatment"
)

# 3. Treatment response from raw measurements (one row per patient per visit)
data("waterfall_raw_longitudinal", package = "OncoPath")
wf_raw <- waterfall(
  data            = waterfall_raw_longitudinal,
  patientID       = "PatientID",
  responseVar     = "Measurement",
  timeVar         = "Time",
  inputType       = "raw",
  measurementUnit = "mm",
  showSpiderPlot  = TRUE
)

# 4. Diagnostic test accuracy meta-analysis
data("diagnosticmeta_test_categorical", package = "OncoPath")
dta <- diagnosticmeta(
  data            = diagnosticmeta_test_categorical,
  study           = "study",
  true_positives  = "true_positives",
  false_positives = "false_positives",
  false_negatives = "false_negatives",
  true_negatives  = "true_negatives",
  covariate       = "imaging_modality",
  heterogeneity_analysis = TRUE,
  meta_regression = TRUE
)

# 5. IHC heterogeneity: four biopsies against a whole-section reference
data("ihcheterogeneity_test", package = "OncoPath")
ihc <- ihcheterogeneity(
  data         = ihcheterogeneity_test,
  wholesection = "wholesection",
  biopsy1      = "biopsy1",
  biopsy2      = "biopsy2",
  biopsy3      = "biopsy3",
  biopsy4      = "biopsy4",
  spatial_id   = "spatial_id"
)

# Results are jmvcore objects: print one, or read a table as a data frame
wf$summaryTable$asDF
```

------------------------------------------------------------------------

## Example datasets

All example datasets are **synthetic**. They were generated to
demonstrate the analyses and do not come from patients.

In jamovi, open them from the main menu (**☰**) → **Open** → **Data
Library** → **OncoPath**. Each file opens with the analysis already set
up:

| jamovi example | Analysis | Contents |
|:---|:---|:---|
| `swimmerplot_sample.omv` | Swimmer Plot | 20 patients: start and end times in months, best response, four milestone times and an event column |
| `waterfall_percentage_basic.omv` | Treatment Response | 20 patients: best percent change from baseline and treatment arm (Drug A / Drug B) |
| `waterfall_raw_longitudinal.omv` | Treatment Response | 15 patients: tumour measurements at months 0, 2, 4 and 6 |
| `diagnosticmeta_test_categorical.omv` | Diagnostic Test Meta-Analysis | 20 studies: 2x2 counts, year, a quality score and imaging modality (CT 5, MRI 9, ultrasound 6) |
| `ihcheterogeneity_test.omv` | IHC Heterogeneity | 50 cases: whole-section reference, four biopsies and a spatial compartment |

In R, the same data are available with
[`data()`](https://rdrr.io/r/utils/data.html), together with
`diagnostic_studies` (five 2x2 tables) and `histopathology` (a
general-purpose clinicopathological data frame from the ClinicoPath
project, not used by an OncoPath analysis).

------------------------------------------------------------------------

## Documentation and support

- **Website**: <https://www.serdarbalci.com/OncoPath/>
- **ClinicoPath project**:
  <https://www.serdarbalci.com/ClinicoPathJamoviModule/>
- **Source code**: <https://github.com/sbalci/OncoPath/>
- **Bug reports and feature requests**:
  <https://github.com/sbalci/OncoPath/issues>

------------------------------------------------------------------------

## Citation

If you use OncoPath in your research or publications, please cite:

``` bibtex
@manual{balci2026oncopath,
  title  = {OncoPath: Oncology and Pathology Analyses for jamovi},
  author = {Serdar Balci},
  year   = {2026},
  note   = {R package and jamovi module version 1.1.0},
  url    = {https://www.serdarbalci.com/OncoPath/}
}
```

OncoPath has no DOI of its own. The ClinicoPath project, from which it
is distributed, is archived on Zenodo as
[10.5281/zenodo.3997188](https://doi.org/10.5281/zenodo.3997188).

## License

OncoPath is licensed under GPL (\>= 2); see the [GNU licenses
page](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html). It
imports packages under other licences, including `mada` (GPL-2 only),
`ggrepel` (GPL-3), `RColorBrewer` (Apache-2.0) and `ggswim` (MIT). Users
who redistribute OncoPath together with its dependencies should check
that the combination meets their licensing needs.
