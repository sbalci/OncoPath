# Waterfall Plot Raw Longitudinal Dataset

Fifteen synthetic patients for the `waterfall` analysis with raw input
and the spider plot: one row per patient per visit. The values are the
same as in the jamovi example `waterfall_raw_longitudinal.omv`.

## Usage

``` r
waterfall_raw_longitudinal
```

## Format

A data frame with 60 rows and 3 variables:

- PatientID:

  Patient identifier, PT01 to PT15

- Time:

  Visit time in months (0 = baseline, then 2, 4 and 6)

- Measurement:

  Tumour burden at that visit, in mm (for example a sum of diameters), 0
  to 90

## Source

Synthetic data generated for the ClinicoPath project
(`data-raw/waterfall_comprehensive_test_data.R`).
