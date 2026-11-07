# Treatment Response Analysis Documentation

This document provides a comprehensive overview of the Treatment Response Analysis module, detailing its features, user interface elements, and the underlying R functions.

## Feature Summary

The Treatment Response Analysis module creates waterfall and spider plots to visualize tumor response data, with response thresholds adapted from RECIST (Response Evaluation Criteria in Solid Tumors) v1.1. It supports both raw tumor measurements and pre-calculated percentage changes, providing a comprehensive analysis of patient response to treatment.

The module's features can be broadly categorized as follows:

*   **Plotting:** Generates waterfall plots (best response per patient) and spider plots (response trajectories over time).
*   **Data Handling:** Processes raw tumor measurements to calculate percentage changes or uses pre-calculated percentages. Handles missing data and validates input.
*   **Response categories:** Assigns CR, PR, SD and PD from percent-change thresholds adapted from RECIST v1.1. This is not a RECIST v1.1 assessment: one burden value per patient and visit, no target-lesion summation, no new-lesion or non-target assessment, no confirmation.
*   **Group Analysis:** Advanced group-based coloring system for comparing treatment arms, disease subtypes, or other patient groupings.
*   **Clinical Metrics:** Calculates Objective Response Rate (ORR), Disease Control Rate (DCR), and person-time metrics.
*   **Customization:** Options for sorting, thresholds, labeling, color schemes, and plot aesthetics with dual coloring strategies.
*   **Data Export:** Allows adding the calculated response category back to the data.

## Feature Details

The following table provides a detailed mapping of the module's features, from the user interface to the underlying R functions.

| Feature | YAML argument (`.a.yaml`) | UI label | Results section (`.r.yaml`) | R function (`.b.R`) |
| --- | --- | --- | --- | --- |
| **Data** | | | | |
| Patient ID | `patientID` | Patient ID variable | all | `.validateData`, `.processData` |
| Response value | `responseVar` | Response value (raw or percentage) | all | `.validateData`, `.processData` |
| Time variable | `timeVar` | Time variable (required for raw input and spider plot) | `spiderplot`, `responseDurationTable`, `personTimeTable` | `.processData`, `.calculateTimeToEventMetrics` |
| Group variable | `groupVar` | Group variable | `groupComparisonTable`, `groupComparisonTest`, plots | `.processData`, `.generateGroupComparison` |
| Input type | `inputType` | Data input type | all | `.validateData`, `.processData` |
| Unit of raw measurements (5 mm rule) | `measurementUnit` | Unit of raw measurements | categories, TTR/DoR | `.processData`, `.categorizeRECIST` |
| Response category override | `responseCategoryVar` | Response category override (optional) | categories, rates, TTR/DoR | `.applyCategoryOverride` |
| Confirmation markers (display only) | `confirmationVar` | Confirmation status (optional) | `waterfallplot` | `.attachAnnotations` |
| Ongoing arrows | `ongoingVar` | On-Treatment / ongoing (optional) | `waterfallplot` | `.attachAnnotations` |
| Annotation tracks | `annotationVars` | Annotation tracks (below the bars) | `waterfallplot` | `.annotationTrack` |
| **Plotting** | | | | |
| Sort by | `sortBy` | Sort by | `waterfallplot` | `.waterfallplot` |
| Sort direction (conventional: worst on the left) | `sortDirection` | Sort direction | `waterfallplot` | `.waterfallplot` |
| RECIST threshold lines | `showThresholds` | RECIST thresholds | `waterfallplot`, `spiderplot` | `.waterfallplot`, `.spiderplot` |
| Large-change labels | `labelOutliers` | Large-change labels | `waterfallplot` | `.waterfallplot` |
| Median best response line | `showMedian` | Median response | `waterfallplot` | `.waterfallplot` |
| Bootstrap CI of the median | `showCI` | Bootstrap CI of the median | `waterfallplot` | `.waterfallplot` |
| Minimum response for labels | `minResponseForLabel` | Minimum response for labels (percent) | `waterfallplot` | `.waterfallplot` |
| Color by | `colorBy` | Color by | `waterfallplot` | `.waterfallplot` |
| Color scheme | `colorScheme` | Color scheme | `waterfallplot` | `.waterfallplot`, `.generateGroupColors` |
| Bar transparency | `barAlpha` | Bar transparency | `waterfallplot` | `.waterfallplot` |
| Bar width | `barWidth` | Bar width | `waterfallplot` | `.waterfallplot` |
| Waterfall plot | `showWaterfallPlot` | Waterfall plot | `waterfallplot` | `.generateVisualizations` |
| Spider plot | `showSpiderPlot` | Spider plot | `spiderplot` | `.generateVisualizations`, `.spiderplot` |
| Spider plot color by | `spiderColorBy` | Spider plot color by | `spiderplot` | `.spiderplot` |
| Spider plot color scheme | `spiderColorScheme` | Spider plot color scheme | `spiderplot` | `.spiderplot`, `.generateGroupColors` |
| Time unit (labels only) | `timeUnitLabel` | Time unit | `spiderplot`, `clinicalMetrics`, `responseDurationTable` | `.spiderplot`, `.generateTablesAndResults` |
| **Clinical metrics** | | | | |
| Response categories table | `summaryTable` | Response Categories (threshold-based, not full RECIST v1.1) | `summaryTable` | `.calculateMetrics` |
| Clinical response metrics table | `clinicalMetrics` | Clinical Response Metrics | `clinicalMetrics` | `.calculateMetrics`, `.calculatePersonTimeMetrics` |
| Time to response and duration of response | `showResponseDuration` | Time-to-response & duration of response (KM) | `responseDurationTable` | `.calculateTimeToEventMetrics` |
| Person-time table (raw input with a time variable) | — | Person-Time Analysis | `personTimeTable` | `.calculatePersonTimeMetrics` |
| **Data export** | | | | |
| Add response category to data | `addResponseCategory` | Response category column | `addResponseCategory` | `.generateReportsAndContent` |
