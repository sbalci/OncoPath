# Swimmer Plot Sample Dataset

Twenty synthetic patients for the `swimmerplot` analysis. Times are in
months from the start of treatment. The data have no censoring status
column.

## Usage

``` r
swimmerplot_sample
```

## Format

A data frame with 20 rows and 10 variables:

- PatientID:

  Patient identifier, PT001 to PT020

- StartTime:

  Start of follow-up (months; 0 for every patient)

- EndTime:

  End of follow-up (months, 11 to 28)

- Response:

  Best response: CR, PR, SD or PD

- Surgery:

  Time of surgery (months)

- TreatmentStart:

  Time treatment started (months)

- ResponseAssessment:

  Time of the response assessment (months)

- Progression:

  Time of progression (months); NA if none

- EventType:

  Name of a clinical event ("Treatment Start")

- EventTime:

  Time of that event (months)

## Source

Synthetic data generated for the ClinicoPath project.
