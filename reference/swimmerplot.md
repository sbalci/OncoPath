# Swimmer Plot

Creates comprehensive swimmer plots using the ggswim package to
visualize patient timelines, clinical events, milestones, and treatment
responses. Features enhanced data validation and complete ggswim
integration for professional clinical visualization.

## Usage

``` r
swimmerplot(
  data,
  patientID,
  startTime,
  endTime,
  responseVar = NULL,
  censorVar = NULL,
  groupVar = NULL,
  timeType = "raw",
  dateFormat = "ymd",
  timeUnit = "months",
  timeDisplay = "relative",
  maxMilestones = 5,
  milestone1Name = "Surgery",
  milestone1Date = NULL,
  milestone2Name = "Treatment Start",
  milestone2Date = NULL,
  milestone3Name = "Response Assessment",
  milestone3Date = NULL,
  milestone4Name = "Progression",
  milestone4Date = NULL,
  milestone5Name = "Death/Last Follow-up",
  milestone5Date = NULL,
  showEventMarkers = FALSE,
  eventVar = NULL,
  eventTimeVar = NULL,
  laneWidth = 3,
  markerSize = 5,
  plotTheme = "ggswim",
  colorPalette = "default",
  showLegend = TRUE,
  referenceLines = "none",
  customReferenceTime = 12,
  customReferenceDate = "",
  sortVariable = NULL,
  sortOrder = "duration_desc",
  showInterpretation = TRUE,
  personTimeAnalysis = TRUE,
  responseAnalysis = TRUE,
  showGlossary = FALSE,
  showCopyReady = FALSE,
  showAbout = FALSE,
  exportTimeline = FALSE,
  exportSummary = FALSE
)
```

## Arguments

- data:

  The data as a data frame containing patient timeline information.

- patientID:

  Variable containing unique patient identifiers.

- startTime:

  Time/date when observation/treatment started.

- endTime:

  Time/date when observation/treatment ended.

- responseVar:

  Optional variable for response types (e.g., CR, PR, SD, PD) to color
  lanes.

- censorVar:

  Optional variable giving each patient's status. A censored /
  still-at-risk value draws a status arrow at the end of that patient's
  lane and is also what the reverse Kaplan-Meier median follow-up uses.
  Use 0/FALSE/"censored"/"alive" for ongoing patients (shows arrow), or
  1/TRUE/"event"/"dead" for completed follow-up (no arrow). Without a
  censoring variable no arrows are drawn and an information notice says
  so.

- groupVar:

  Optional grouping variable for comparing response rates between
  patient groups (e.g., treatment arms, disease subtypes). When
  specified, Fisher's exact tests compare ORR and DCR between groups.
  Lane colors reflect the response variable, not the group.

- timeType:

  Select whether time values are raw numbers or dates/times.

- dateFormat:

  Select the date/time format in your data (only used when Time Input
  Type is Date/Time).

- timeUnit:

  Time unit to use for display and calculations.

- timeDisplay:

  Choose whether to align all start times to 0 or use absolute start
  times.

- maxMilestones:

  Maximum number of milestone events to support (milestone slots 1-5 are
  defined).

- milestone1Name:

  Name for the first milestone event (e.g., Surgery, Treatment Start).

- milestone1Date:

  Date/time variable when milestone 1 occurred.

- milestone2Name:

  Name for the second milestone event.

- milestone2Date:

  Date/time variable when milestone 2 occurred.

- milestone3Name:

  Name for the third milestone event.

- milestone3Date:

  Date/time variable when milestone 3 occurred.

- milestone4Name:

  Name for the fourth milestone event.

- milestone4Date:

  Date/time variable when milestone 4 occurred.

- milestone5Name:

  Name for the fifth milestone event.

- milestone5Date:

  Date/time variable when milestone 5 occurred.

- showEventMarkers:

  Whether to display event markers along patient timelines.

- eventVar:

  Variable containing event type labels for markers.

- eventTimeVar:

  Variable containing event times (defaults to start time if not
  specified).

- laneWidth:

  Width/thickness of patient timeline lanes.

- markerSize:

  Size of event markers and milestone markers.

- plotTheme:

  Visual theme for the swimmer plot. "jamovi (follow global)" uses the
  plot theme selected in jamovi's preferences, so the figure matches
  every other plot in the document; the ggswim themes are a deliberate
  swimmer-plot look and remain the default.

- colorPalette:

  Select the color palette for the response categories that color the
  lanes; it has no effect unless a Response/Status variable is selected,
  and the grouping variable is never used for color. Colorblind Safe
  uses perceptually uniform colors distinguishable by all color vision
  types. High Contrast is optimized for projectors and printing, and
  gives way to Colorblind Safe above its eight colors. Monochrome
  ensures clarity in grayscale publications.

- showLegend:

  Whether to display the plot legend.

- referenceLines:

  Add reference time lines to the plot for clinical context. Median and
  Protocol lines measure a duration from each patient's own start, so
  they are drawn only where the axis measures duration: with Time
  display set to Absolute and patients starting at different times they
  are omitted and a note explains why.

- customReferenceTime:

  Custom time point to mark with a reference line (only used when
  Reference Lines is set to Custom).

- customReferenceDate:

  When using Date/Time with Absolute display, provide a calendar date
  (e.g., 2023-06-01) to draw a custom reference line. If left blank, the
  Custom Reference Time is used as an offset from the earliest start
  date.

- sortVariable:

  Optional variable to sort patient timelines. When one is selected it
  overrides the Sort order setting; leave it empty to sort by duration,
  patient ID or response.

- sortOrder:

  How to order patients in the visualization, read from the top of the
  plot down. Ignored while a Sort by variable is selected. Response Type
  falls back to duration order when no Response/Status variable is
  supplied.

- showInterpretation:

  Whether to display automated clinical interpretation of the timeline
  data.

- personTimeAnalysis:

  Whether to include epidemiological person-time metrics in the
  analysis.

- responseAnalysis:

  Whether to analyze response patterns when response variable is
  provided.

- showGlossary:

  Display a glossary of clinical terms and statistical concepts used in
  the analysis.

- showCopyReady:

  Generate copy-ready text suitable for manuscripts and clinical
  reports.

- showAbout:

  Display information about when and how to use swimmer plot analysis.

- exportTimeline:

  Export processed timeline data for external analysis. The on-screen
  table shows at most the first 500 patients, because building it is
  slow for large cohorts; the plot, the statistics and every other table
  continue to use the whole cohort.

- exportSummary:

  Export comprehensive summary statistics and clinical metrics.

## Value

A results object containing:

|                               |     |     |     |     |                |
|-------------------------------|-----|-----|-----|-----|----------------|
| `results$notices`             |     |     |     |     | a preformatted |
| `results$instructions`        |     |     |     |     | a html         |
| `results$plot`                |     |     |     |     | an image       |
| `results$summary`             |     |     |     |     | a table        |
| `results$interpretation`      |     |     |     |     | a html         |
| `results$personTimeTable`     |     |     |     |     | a table        |
| `results$milestoneTable`      |     |     |     |     | a table        |
| `results$eventMarkerTable`    |     |     |     |     | a table        |
| `results$timelineData`        |     |     |     |     | a table        |
| `results$summaryData`         |     |     |     |     | a table        |
| `results$exportInfo`          |     |     |     |     | a html         |
| `results$advancedMetrics`     |     |     |     |     | a table        |
| `results$groupComparisonTest` |     |     |     |     | a table        |
| `results$clinicalGlossary`    |     |     |     |     | a html         |
| `results$copyReadyReport`     |     |     |     |     | a html         |
| `results$aboutAnalysis`       |     |     |     |     | a html         |

Tables can be converted to data frames with `asDF` or
[`as.data.frame`](https://rdrr.io/r/base/as.data.frame.html). For
example:

`results$summary$asDF`

`as.data.frame(results$summary)`
