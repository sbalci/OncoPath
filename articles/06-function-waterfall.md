# Vignette: Creating Waterfall Plots

## What a Waterfall Plot Is For

One bar per patient, sorted, showing the change in tumour burden from
baseline. It is the standard first figure of a response-evaluable trial
cohort because it shows the whole distribution rather than a single
response rate — you can see at a glance whether a 35% response rate came
from a few dramatic responders or from many patients sitting just past
the threshold.

`waterfall` takes either **percentage change already calculated**, or
**raw measurements over time** from which it calculates the change
itself and can additionally draw a spider plot.

## Percentage Input

The bundled `waterfall_percentage_basic` dataset has one row per patient
with the change already computed.

``` r

library(OncoPath)

data(waterfall_percentage_basic, package = "OncoPath")
head(waterfall_percentage_basic)
#>   PatientID Response Treatment
#> 1      PT01     -100    Drug A
#> 2      PT02      -85    Drug A
#> 3      PT03      -60    Drug A
#> 4      PT04      -45    Drug A
```

``` r

res <- waterfall(
  data        = waterfall_percentage_basic,
  patientID   = "PatientID",
  responseVar = "Response",
  inputType   = "percentage",
  sortBy      = "response",

  showThresholds           = TRUE,   # the -30% and +20% RECIST lines
  showMedian               = TRUE,
  labelOutliers            = TRUE,
  showCategoryLabels       = TRUE,   # CR/PR/SD/PD above each bar
  showClinicalSignificance = TRUE,
  showConfidenceIntervals  = TRUE    # CIs on ORR and DCR
)
```

### RECIST Categories

     category n percent
           CR 1    0.05
           PR 6    0.30
           SD 9    0.45
           PD 4    0.20

### Clinical Metrics, With Uncertainty

                            metric value ci_lower ci_upper
     Objective Response Rate (ORR) 35.0%     15.4     59.2
        Disease Control Rate (DCR) 80.0%     56.3     94.3

`showConfidenceIntervals` is on by default and worth leaving on. An ORR
of 35% in 20 patients has a 95% interval running from 15% to 59% — the
point estimate alone invites a confidence the data do not support, and
this is exactly the figure that ends up in a slide deck.

The interpretation text that accompanies these figures is deliberately
hedged (“general benchmark; verify against tumor-specific thresholds”).
A 35% ORR means something different in pancreatic cancer than in
melanoma, and the analysis has no way to know which you are looking at.

## Raw Longitudinal Input and the Spider Plot

With repeated measurements per patient, give `waterfall` the time
variable and set `inputType = "raw"`. It computes the change from
baseline itself and can draw a spider plot of the individual
trajectories alongside the waterfall.

``` r

data(waterfall_raw_longitudinal, package = "OncoPath")
head(waterfall_raw_longitudinal)
#>   PatientID Time Measurement

res_spider <- waterfall(
  data        = waterfall_raw_longitudinal,
  patientID   = "PatientID",
  responseVar = "Measurement",
  timeVar     = "Time",
  inputType   = "raw",

  showWaterfallPlot    = TRUE,
  showSpiderPlot       = TRUE,
  timeUnitLabel        = "months",  # generic | days | weeks | months | years
  showSpiderLabels     = TRUE,      # label each line with its patient ID
  showResponseDuration = TRUE       # time-to-response and duration-of-response table
)
```

`showResponseDuration` needs the time variable, so it is only available
on raw input. Duration of response is often the more clinically
meaningful endpoint of the two: a 40% shrinkage that lasts three months
and one that lasts two years produce the same waterfall bar.

## Options Worth Knowing About

Several of these were undocumented until now.

| Option | Default | What it does |
|----|----|----|
| `sortDirection` | `"conventional"` | `"conventional"` puts the best responses on the left, as in published figures. `"reverse"` flips it. (Not `"decreasing"` — that value is rejected.) |
| `showBaseline` | `TRUE` | The Y = 0 reference line |
| `showCategoryLabels` | `FALSE` | RECIST category above each bar |
| `confirmationVar` | — | A column marking which responses were confirmed on a later scan. Unconfirmed responses overstate activity |
| `ongoingVar` | — | A column marking patients still on treatment, whose responses may deepen |
| `responseCategoryVar` | — | Override the computed RECIST category with an investigator-assigned one |
| `annotationVars` | — | Extra tracks drawn below the bars (mutation status, prior lines, and so on) |
| `showResponseDuration` | `FALSE` | Time-to-response and duration-of-response; needs `timeVar` |
| `showSpiderLabels` | `FALSE` | Patient ID on each spider line |
| `timeUnitLabel` | `"generic"` | Axis label for the spider plot |
| `showClinicalSignificance` | `FALSE` | Clinical-significance threshold annotations |
| `showConfidenceIntervals` | `TRUE` | Confidence intervals on ORR and DCR |
| `generateCopyReadyReport` | `FALSE` | A paste-ready results paragraph |
| `showExplanations` | `FALSE` | Notes explaining each output |
| `enableGuidedMode` | `FALSE` | Step-by-step prompts for first-time users |

## A Caveat on Sorting

Sorting by response is what makes the figure readable, and it is also
what makes it easy to over-read. The bars are ordered by outcome, so any
left-to-right pattern in an annotation track below them is a consequence
of that ordering, not evidence of association. If you want to test
whether a biomarker predicts response, test it — do not read it off the
waterfall.
