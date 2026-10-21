# Diagnostic Studies Sample Dataset

Five synthetic diagnostic accuracy studies (2x2 tables) for the
`diagnosticmeta` analysis. Five studies are too few for heterogeneity or
meta-regression; use `diagnosticmeta_test_categorical` for those.

## Usage

``` r
diagnostic_studies
```

## Format

A data frame with 5 rows and 5 variables:

- study_name:

  Study identifier

- tp:

  Number of true positive results

- fp:

  Number of false positive results

- fn:

  Number of false negative results

- tn:

  Number of true negative results

## Source

Synthetic data generated for the ClinicoPath project.
