# Swimmer Plot Analysis Documentation

This document gives an overview of the Swimmer Plot analysis: its features, the user interface elements and the R functions behind them.

## Feature Summary

The Swimmer Plot analysis draws one lane per patient with the `ggswim` package, from each patient's start to end time, colored by response, with optional milestones, event markers and status arrows for censored patients. It reports the objective response rate (ORR) and disease control rate (DCR) with exact confidence intervals over every patient in the analysis, median follow-up (reverse Kaplan-Meier when a readable censoring status is supplied, otherwise the plain median of observed durations, labeled as such), person-time by best response, milestone and event-marker summaries, and Fisher's exact tests of ORR and DCR between patient groups.

## Feature Details

The table maps each feature from the user interface to the underlying R functions. UI labels are the titles shown in jamovi.

| Feature | YAML Argument (`.a.yaml`) | UI Label | Results Section (`.r.yaml`) | R Function (`.b.R`) |
| --- | --- | --- | --- | --- |
| **Core Data Variables** | | | | |
| Patient ID | `patientID` | Patient ID | all outputs | `.validateAndProcessData`, `.summarizeByPatient` |
| Start time | `startTime` | Start time | all outputs | `.validateAndProcessData`, `.calculateFollowUp` |
| End time | `endTime` | End time | all outputs | `.validateAndProcessData`, `.calculateFollowUp` |
| Response | `responseVar` | Response/Status variable | `plot`, `summary`, `personTimeTable`, `advancedMetrics`, `groupComparisonTest`, `copyReadyReport` | `.getBestResponse`, `.normalizeResponses`, `.responseRates`, `.calculateSummaryStats` |
| Censoring status | `censorVar` | Censoring/Event status variable | `plot` (status arrows), `advancedMetrics` (median follow-up) | `.censorCoding`, `.processOngoingStatus`, `.calculateMedianFollowUp` |
| Censoring coding | `censorCoding` | Censoring coding | `notices`, `plot`, `advancedMetrics` | `.censorCoding`, `.censorCodingNotice` |
| Grouping variable | `groupVar` | Grouping variable | `groupComparisonTest` | `.updateGroupComparisonTests` |
| **Time Processing** | | | | |
| Time input type | `timeType` | Time input type | all outputs | `.validateAndProcessData`, `.parseDatesWithClinicalContext` |
| Date format | `dateFormat` | Date format in data | all outputs | `.parseDatesWithClinicalContext`, `.parseCustomReferenceDate` |
| Time unit | `timeUnit` | Time unit | all outputs | `.validateAndProcessData`, `.calculateFollowUp`, `.mergeIntervalsAndSum` |
| Time display | `timeDisplay` | Time display mode | `plot` | `.validateAndProcessData`, `.processMilestones`, `.processEventMarkers` |
| **Milestones** | | | | |
| Maximum milestones | `maxMilestones` | Maximum milestones | `milestoneTable` | `.processMilestones` |
| Milestone 1-5 name | `milestone1Name` ... `milestone5Name` | Milestone 1 name ... Milestone 5 name | `plot`, `milestoneTable` | `.processMilestones` |
| Milestone 1-5 time | `milestone1Date` ... `milestone5Date` | Milestone 1 date ... Milestone 5 date | `plot`, `milestoneTable` | `.processMilestones`, `.updateMilestoneTable` |
| **Event Markers** | | | | |
| Event markers | `showEventMarkers` | Event markers | `plot`, `eventMarkerTable` | `.processEventMarkers`, `.updateEventMarkerTable` |
| Event type | `eventVar` | Event type variable | `plot`, `eventMarkerTable` | `.processEventMarkers` |
| Event time | `eventTimeVar` | Event time variable | `plot`, `eventMarkerTable` | `.processEventMarkers` |
| **Visualization** | | | | |
| Lane width | `laneWidth` | Lane width | `plot` | `.createGgswimPlot` |
| Marker size | `markerSize` | Marker size | `plot` | `.createGgswimPlot` |
| Plot theme | `plotTheme` | Plot theme | `plot` | `.createGgswimPlot` |
| Color palette | `colorPalette` | Color palette | `plot` | `.createGgswimPlot` |
| Legend | `showLegend` | Legend | `plot` | `.createGgswimPlot` |
| Reference lines | `referenceLines` | Reference lines | `plot` | `.addReferenceLines` |
| Custom reference time | `customReferenceTime` | Custom reference time | `plot` | `.addReferenceLines` |
| Custom reference date | `customReferenceDate` | Custom reference date | `plot` | `.addReferenceLines`, `.parseCustomReferenceDate` |
| **Sorting** | | | | |
| Sort by variable | `sortVariable` | Sort by variable | `plot`, `timelineData` | `.applySorting` |
| Sort order | `sortOrder` | Sort order | `plot`, `timelineData` | `.applySorting` |
| **Analysis Options** | | | | |
| Clinical interpretation | `showInterpretation` | Clinical interpretation | `interpretation` | `.generateClinicalInterpretation`, `.generateInterpretationOutput` |
| Person-time analysis | `personTimeAnalysis` | Person-time analysis | `personTimeTable`, `advancedMetrics` | `.updatePersonTimeTable`, `.updateAdvancedMetrics` |
| Response analysis | `responseAnalysis` | Response analysis | `summary`, `personTimeTable`, `advancedMetrics`, `groupComparisonTest` | `.calculateSummaryStats`, `.updateAdvancedMetrics`, `.updateGroupComparisonTests` |
| Clinical glossary | `showGlossary` | Clinical glossary | `clinicalGlossary` | `.generateClinicalGlossary` |
| Copy-ready text | `showCopyReady` | Copy-ready manuscript text | `copyReadyReport` | `.generateCopyReadyReport` |
| About | `showAbout` | About this analysis | `aboutAnalysis` | `.generateAboutAnalysis` |
| **Export** | | | | |
| Timeline data | `exportTimeline` | Timeline data | `timelineData`, `exportInfo` | `.updateExportData` |
| Summary statistics | `exportSummary` | Summary statistics | `summaryData`, `exportInfo` | `.updateExportData` |

## Notes on Behavior

- ORR and DCR are computed over every patient in the analysis; patients recorded as NE or with no response count as non-responders. They are withheld when any response value is not CR, PR, SD, PD or NE.
- When a patient has different responses on different rows, the category used is the best response recorded up to and including the first PD, unconfirmed; a value repeated on each of a patient's rows is used as it is.
- Rows with a missing or unreadable patient ID, start or end time are excluded, and a notice says how many and which responses and censoring values they carried.
- A grouping variable whose value differs between a patient's rows skips the group comparison only, with a notice.
