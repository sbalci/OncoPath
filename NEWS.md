# OncoPath 1.0.6.04 (2026-08-23)

All four analyses went through a full audit, fix, review and release-review cycle this week, each
closed by an adversarial verification pass that re-derived every changed statistic against an
independent implementation. Two analyses carry breaking option changes; they are listed first.

## Breaking changes

- **`diagnosticmeta`: two zero-cell correction keys were renamed.**`treatment_arm` is now
  `zero_cells` and `empirical` is now `reciprocal_n`. The old names are the literature's terms
  (Sweeting et al. 2004) for procedures this analysis never implemented -- "treatment-arm" adds 0.5 to
  every cell of the affected study, and "empirical" uses the reciprocal of the opposite-arm size --
  whereas the code adds 0.5 to the zero cells only, or 1/N to all cells. The options now say what they
  do. R callers passing the old keys get a clear "must be one of" error; the jamovi GUI is unaffected.
- **`ihcheterogeneity`: the `bias` analysis focus was removed.**It was computationally identical to
  `reproducibility` (one sentence of prose apart; the bias table is computed whenever a reference is
  supplied regardless of focus). The `reproducibility` level is retitled "Reproducibility & Bias
  Assessment". R callers passing `analysis_type = "bias"` get a clear error.
- **`ihcheterogeneity`: the report-sentences and methodology panels are now opt-in.**Two new
  options, "Copy-ready report sentences" and "Methodology & assumptions" (both off by default),
  gate roughly 7 KB of explanatory HTML that previously rendered on every run.

## `diagnosticmeta` -- Fixed, statistical

- **The proportional-hazards SROC table tested the wrong null hypotheses.**Both parameters were
  tested against zero. For theta the no-accuracy null is theta = 1 (the chance diagonal; theta near 0
  is a near-perfect test), so the printed p-value rewarded good tests for the wrong reason. The
  between-study variance cannot be Wald-tested against zero at all (it sits on the boundary of its
  parameter space). Theta is now tested against 1, the variance carries no p-value, and a table note
  explains both.
- **The bivariate and SROC sections were fitted to different data.**Under the default zero-cell
  setting the bivariate model received mada's "single" continuity correction (0.5 added only to
  zero-cell studies) while `mada::phm` ran on its library default, which corrects every study when
  any zero cell exists. Both now use the same policy.
- **Prediction intervals use t on k-2 degrees of freedom,**not a normal quantile, per Riley et al.
  2011. With the small study counts typical of diagnostic meta-analysis the normal interval was
  materially too narrow -- understating exactly the between-study uncertainty the interval exists to
  show. The table note names the distribution and degrees of freedom used.
- **Meta-regression gained the Knapp-Hartung adjustment and an omnibus test.**Inference is t-based
  (z for fixed-effect models, where the adjustment is undefined), an omnibus QM/F test is reported per
  model so a multi-level factor covariate can be judged as a whole, and the output now says plainly
  that two separate univariate models (logit sensitivity, logit specificity) are fitted -- not a joint
  bivariate meta-regression. The statistic column is retitled accordingly.
- **The fitted between-study variance components are reported:**tau-squared for logit sensitivity
  and logit false-positive rate, and the correlation between logit sensitivity and logit specificity
  (the threshold-effect indicator), sign-corrected for mada's parameterisation and flagged when it is
  estimated at the +/-1 boundary.
- **The Deeks funnel plot and Deeks' test now describe the same studies.**The test applied a 0.5
  correction to zero-cell studies so their odds ratio was finite; the plot computed the odds ratio
  on raw counts, so those same studies became infinite and were silently dropped from the figure.
  The plot now applies the identical correction and says so in its subtitle.
- **Per-study Wilson score confidence intervals were added to the Individual Study Results table,**
  the same intervals the forest plot draws, honouring the chosen confidence level.

## `diagnosticmeta` -- Fixed, behaviour and presentation

- **Warnings have a home.**Every runtime warning -- excluded studies, substantial heterogeneity,
  meta-regression failures, the small-k Deeks caution, zero-cell corrections -- used to be appended
  to the end of the ninety-line "Getting Started" panel, with Bootstrap alert classes jamovi does not
  style, and nothing reset them between runs, so the same banner accumulated once per option change.
  They now render in a dedicated Notices panel at the top of the results, rebuilt on every run.
- **The meta-regression checkbox's enable rule was written in R syntax**and never engaged; the
  checkbox was always enabled. It now enables only when a covariate is assigned.
- **Two display checkboxes were dead until every variable was assigned**(Analysis Summary,
  Clinical Interpretation) and Clinical Interpretation stayed hidden after a too-few-studies
  rejection, because `.init()` hid the panels imperatively and the restore sat on an unreachable
  path. The declarative visibility rules now govern.
- The "high contrast" palette drew white points on the white plot background; the instructions said
  "at least 2 studies" while the analysis requires 3 and documented a "DerSimonian-Laird" method that
  is not in the menu; stale summary and SROC content survived method and model-toggle changes; the
  zero-cell correction control sat outside every section; table notes were HTML-escaped (apostrophes
  showed as `&#39;`); internal method keys ("reml") appeared in notes; mada's "non zero decimal
  places" warning fired on every corrected run. All corrected.

## `ihcheterogeneity` -- Fixed, statistical

- **The spatial plot measured the wrong thing.**It pooled every measurement of every case in a
  compartment into one coefficient of variation -- between-patient biological spread -- while the
  spatial table beside it (correctly) averaged per-case CVs. The two could rank compartments in
  opposite orders on one screen. The plot now uses the table's per-case computation.
- **The Kruskal-Wallis compartment test treated 4-5 measurements per patient as independent
  observations,**inflating its sample size roughly k-fold and biasing the p-value anticonservatively.
  It now compares one per-case summary value per patient and says so in a note.
- **One biopsy against the whole section is allowed again.**The reference + single-region design --
  the classic agreement question -- was rejected by a gate written for inter-regional studies, and the
  ICC gate counted regions rather than measurement columns, so even when allowed it would have
  fallen back to a correlation. ICC(2,1) for this design now matches `psych::ICC` exactly.
- **Every panel grades variability and correlation against the thresholds you set.**The Key Findings
  line, the spatial table and plot, the plain-language summary and the variability plot's reference
  lines each carried their own hard-coded bands (15/30, 0.80/0.60), so one run could call the same
  CV "Low" in one place and "Moderate" or "High" in another -- including at the default threshold.
  All now use the configured CV and correlation thresholds, with the bands stated in a note.
- The required sample size for the observed-effect power row omitted the Spearman variance
  inflation its own power calculation applied (about 6% understated); the "stratified" sampling
  note falsely claimed "results are adjusted for sampling design effects" when no adjustment exists
  anywhere in the analysis.

## `ihcheterogeneity` -- Fixed, behaviour and presentation

- **Tables no longer duplicate their rows**when jamovi re-runs the analysis after a data-cell edit,
  which does not trigger the clear-on-change rules.
- Empty data, a spatial variable with fewer than two usable regions, regions with a single case, and
  a power-analysis request without a reference measurement each produced a blank or silently-empty
  output; each now explains itself. A latent crash in the psych-missing fallback (a note written to a
  panel type that has none) is fixed. Six white panels were unreadable in jamovi's dark theme.

## `swimmerplot` and `waterfall`

- **Response rates use the RECIST-evaluable population**(CR, PR, SD, PD) as the denominator in both
  analyses, disclosed in the output, with confidence intervals computed on that denominator.
- **`swimmerplot`:**datetime event markers were shifted twice; milestones on an epoch date are
  refused with a message rather than plotted at zero; median follow-up uses the reverse Kaplan-Meier
  method (Schemper & Smith); progression is referenced to the nadir; ISO-formatted date strings are
  detected; the HTML builders moved to `R/swimmerplot_html.R` and the static explanatory blocks were
  wrapped for translation.
- **`waterfall`:**warnings are guaranteed to render even when the analysis stops early; fixed-row
  tables are built once rather than rebuilt every run; nadir-related wording corrected.

## Testing

Each analysis ships with a release-review test file that pins the defects above against independent
references (`mada::reitsma`, `mada::phm`, `metafor::rma`, `psych::ICC`, `irr::icc`,
`stats::kruskal.test`, hand-coded Deeks 2005 and Fisher-z formulas). Combined suites at release:
`diagnosticmeta` 266, `ihcheterogeneity` 215 assertions, 0 failures, 0 errors. Every option panel was
rendered headlessly in jamovi's own client with no swallowed exception.

# OncoPath 1.0.6.03 (2026-08-22)

This release corrects interpretation text that overstated what the statistics support, removes
clinical advice from results, and stops third-party package notices appearing in the results pane.

## Fixed -- statements that were not true

- **`diagnosticmeta`: a non-significant Deeks' test no longer means low publication-bias risk.**The
  Clinical Interpretation panel read a non-significant result as evidence that publication bias is
  unlikely. Deeks' funnel-plot asymmetry test is recommended only when at least ten studies are
  available and has low power below that, so a non-significant result there is uninformative rather
  than reassuring. The panel now reports what was tested, states how many studies entered it, and
  explains that failing to detect asymmetry does not establish its absence.

- **`ihcheterogeneity`: the sampling verdict is named for what it measures.**A verdict reading
  "ADEQUATE SAMPLING" was issued from correlation and coefficient-of-variation thresholds alone. It
  is renamed to state that the agreement thresholds were met, which is what the computation
  actually shows, and the accompanying text no longer implies the sampling strategy is validated for
  use.

## Changed -- results no longer give clinical advice

- Verdicts on fitness for clinical use and instructions about patient management have been replaced
  by descriptions of what was measured and how to read it. Methodological guidance about running the
  analysis is unchanged.

## Fixed -- output hygiene

- **R package chatter no longer appears in Analysis Notes.**jamovi surfaces `message()` and
  `warning()` conditions to the user, so third-party notices leaked into results. Package chatter
  and deprecation notices are now suppressed at the call sites, while substantive warnings still
  reach you.

- **A malformed reference no longer prevents results from rendering.**A citation with an empty
  publication year caused a serialization failure that produced no output at all, with an error
  mentioning `serialize` rather than anything about the analysis. All references now carry a year.

# OncoPath 1.0.4 (2026-08-07)

No statistical changes. Two runtime dependencies were added to `Imports`, and the documentation was
overhauled.

## Fixed

- **`ggrepel` and `patchwork` were used at runtime but not declared.**`R/waterfall.b.R` calls
  `patchwork::wrap_plots` when assembling multi-panel figures and `ggrepel::geom_text_repel` when
  labelling outliers, but neither package appeared in `DESCRIPTION`. jamovi installs a module's
  `Imports` the first time it is used and cannot fetch a missing package on demand, so a user
  without these already installed would have hit a failure at plot time rather than at install
  time. Both are now in `Imports` (22 packages, one per line).

## Note

- Apart from the dependency fix above, this is a version and date bump: 1.0.3 -> 1.0.4 across
  `DESCRIPTION`, `jamovi/0000.yaml` and the four analysis definitions, plus `temp/` and `backups/`
  added to `.Rbuildignore` and `.gitignore`. No statistical method and no output definition changed
  between 1.0.3 and this release. Everything substantive from this development cycle is documented
  under 1.0.3 below, which was tagged without release notes.

## Documentation

All 21 files under `vignettes/` were audited against `jamovi/0000.yaml` and the generated wrapper
signatures. These articles are published to <https://www.serdarbalci.com/OncoPath/articles/>;
`vignettes/` is excluded by `.Rbuildignore` and there is no `VignetteBuilder`, so none of this
affects `R CMD check`. Every example added below was executed against the bundled datasets before
being written down.

- **Option coverage went from 56% to 100%.**Of the 120 options across the four shipped analyses,
  53 were not mentioned anywhere in the documentation; none remain.
- **`ihcheterogeneity` had no documentation whatsoever** -- 18 of its 19 options were unmentioned and
  no article referred to it. `ihcheterogeneity-comprehensive.Rmd` is new: what the analysis is for
  (a biopsy score describes the core, not the tumour), the data layout, a worked run reporting
  ICC(2,1) 0.663 against ICC(3,1) 0.658 and why both are shown, the variance decomposition that
  attributes 34.2% of total variance to within-case sampling, and why the post-hoc power row should
  not be used for planning.
- **The 447-line `diagnosticmeta` article never called `diagnosticmeta()`.**It described the
  bivariate and HSROC models at length without a single executable example, so the argument names
  and their scales appeared nowhere. It now carries a worked run against the bundled
  `diagnostic_studies` data with the returned pooled sensitivity (75.5%, CI 69.1-80.9),
  specificity (89.8%, CI 85.7-92.8), HSROC parameters, heterogeneity and Deeks' test. Two argument
  traps are called out: `confidence_level` is a **percentage on a 50-99 scale** (passing `0.95`
  errors), and `zero_cell_correction` has no `continuity` level -- the four accepted values are
  `none`, `constant`, `treatment_arm` and `empirical`. The Deeks' result on five studies is
  presented as a caveat rather than a finding, since the test needs roughly ten.
- **The waterfall article demonstrated nothing.**`06-function-waterfall.Rmd` pulled a dataset from
  `ClinicoPathDescriptives`, called `library(ClinicoPath)` rather than `library(OncoPath)`, and its
  three code chunks printed placeholder strings with `cat()` instead of calling `waterfall()`. It
  has been rewritten around the bundled `waterfall_percentage_basic` and
  `waterfall_raw_longitudinal` datasets, with the RECIST category breakdown and clinical metrics it
  actually returns (ORR 35.0%, CI 15.4-59.2; DCR 80.0%, CI 56.3-94.3), the raw/spider input path,
  and a table of the fifteen previously-undocumented options. Note `sortDirection` takes
  `"conventional"` or `"reverse"`, not `"decreasing"`.
- **`swimmerplot`'s `censorVar` was undocumented**, along with `customReferenceDate`,
  `showGlossary`, `showCopyReady` and `showAbout`. `censorVar` matters more than its obscurity
  suggests: without it a bar that ends because follow-up ended is drawn the same as one that ends
  because the event occurred, which is the commonest way a swimmer plot misleads.
- **Seven articles refer to analyses OncoPath does not ship, and now say so.**
  `clinicalheatmap`, `ggoncoplot`, `recist`, `classification`, `decisiongraph`, `digitalvalidation`
  and `haralicktexture` are all on development or test menu routes in the umbrella ClinicoPath
  module and reach no user today. Separately, several articles use `agreement` (**meddecide**) and
  `survival` (**jsurvival**), and now name the module to install for those steps. Nothing was
  deleted.

# OncoPath 1.0.3 (2026-08-05)

An end-to-end pre-release review of all four shipped analyses -- `waterfall`, `swimmerplot`,
`diagnosticmeta` and `ihcheterogeneity` -- reading each chain from the user interface through the
backend to the rendered output, and checking every statistic against an independent implementation.
Several of the defects below changed reported response rates, durations of response, variance
components and publication-bias conclusions, so results produced with earlier versions of these
analyses should be re-run.

## Fixed

### Treatment Response (`waterfall`)

- **Progression was measured from baseline instead of from the patient's nadir.**RECIST v1.1
  defines progressive disease relative to the smallest tumour burden recorded so far, not relative
  to the first scan. A patient going 100 -> 60 -> 78 mm is +30% over their nadir -- progression -- but
  still -22% from baseline, so they were counted as censored and their duration of response ran on
  to last follow-up. Every duration-of-response summary and the Kaplan-Meier curve built from it
  were inflated. `.progressionTimes()` now carries the running `cummin()` of the burden.
- **A response-category override outside CR/PR/SD/PD was silently converted to `NA`.**
  `recist_category` is a factor with levels CR/PR/SD/PD/Unknown, so assigning an unrecognised label
  produced `NA` with only an invalid-factor-level warning. If every row was overridden the whole
  column went `NA` and the run aborted downstream with `missing value where TRUE/FALSE needed`.
  Unrecognised labels are now reported and rejected.
- **Objective response and disease control rates were computed over assessment rows, not patients,
  on some processing paths.**The same 90-observation dataset gave ORR 100% when it held 30 patients
  with 3 rows each and ORR 33.3% when it held 60 patients with 3 rows each, because the row count
  decides which processing path runs. Every path now collapses to one row per patient before
  counting, and unevaluable rows no longer inflate the denominator.
- **Physical limits on tumour measurements were never enforced.**The Response Value option text had
  always promised that shrinkage would be capped at -100%, and the code never applied the cap. Worse,
  a negative raw measurement flips the sign of `((current - baseline) / baseline)`, so a growing
  tumour was reported as a response. Both are now handled at a single convergence point
  (`.enforceMeasurementLimits()`), and the cap is announced in the always-visible notices panel
  rather than the validation panel that is cleared when validation otherwise passes.
- **Patients dropped for a missing or zero baseline simply vanished from the cohort, and patients
  with only a baseline scan were scored SD.**With a time variable, a baseline-only patient produced
  `((baseline - baseline) / baseline) x 100` = 0% change and was categorised as stable disease,
  although a patient with no post-baseline assessment is not response-evaluable at all. Both groups
  are now reconciled against the input and reported.
- **The exported response-category column was written against the wrong patients.**The path without
  a time variable took `rownames()` of a dplyr tibble -- always `"1"`...`"k"`, never the source row
  numbers -- after that frame had been collapsed to one row per patient and re-sorted into patient-ID
  order. Rows are now matched back by patient ID.
- **The ORR/DCR confidence intervals used a different denominator from the rates themselves.**The
  interval was computed on `nrow()`, which includes Unknown and unevaluable patients, while the point
  estimate counted only CR/PR/SD/PD -- so the printed rate could fall outside its own interval, for
  example ORR 50.0% displayed with a 95% CI of 28.8-46.8%. The copy-ready report sentences shared the
  same defect and the same fix.
- **The copy-ready "Main Results" paragraph rendered as nothing whenever a response category had no
  patients.**`dplyr::count()` drops unobserved factor levels, so subsetting for an absent category
  returned `integer(0)` -- not `NULL`, so the `%||% 0` fallback never fired -- and `sprintf()` with a
  zero-length argument returns `character(0)`, which `paste0()` then collapses away.
- **The to-do, validation and clinical-summary panels ignored guided mode and were always on
  screen.**A jamovi `visible:` expression beginning with `!` fails jmvcore's routing regex, so
  `(!enableGuidedMode)` evaluated to a raw truthy string. Rewritten as `(enableGuidedMode:FALSE)`.
- **The waterfall and spider plots did not refresh when `barAlpha`, `barWidth`,
  `minResponseForLabel`, `seed`, `timeVar`, `annotationVars` or `showCategoryLabels` changed.**Those
  options are read when the figure is drawn but were missing from `clearWith`.

### Swimmer Plot (`swimmerplot`)

- **"Relative (all start from 0)" anchored each row at zero instead of each patient.**A swimmer plot
  is multi-row per patient by construction, so row-wise rebasing stacked every episode of a patient
  back onto t = 0, corrupting total person-time, mean and median duration, follow-up density and the
  reverse Kaplan-Meier median -- in the default configuration, and invisibly in any fixture with one
  row per patient. Lanes, milestones and events are now all measured from the patient's earliest
  start.
- **Milestone markers were paired with lanes by position, so they landed on the wrong patients.**
  Milestone columns were read from the unfiltered data while the patient table had already had rows
  removed; one dropped row shifted every later patient's markers onto somebody else's lane and
  discarded the last patient's milestone, silently, in both the figure and the Milestone Event
  Summary. For multi-episode patients the same milestone was also handed to both rows, double-counting
  it and producing a negative re-based copy on the later episode. Milestones are now collapsed to one
  row per patient and realigned by patient ID.
- **Ongoing-treatment arrows were inferred from the longest follow-up.**Treating "largest end time"
  as evidence of still being on treatment at data cutoff is wrong in the common case -- the patient
  with the longest follow-up is often the one who died last. Arrows are now drawn only from an
  explicit censoring variable, using the same helper as the median-follow-up calculation, and no
  arrows are drawn when there is none.
- **Every event-marker glyph was the empty string, so event markers were invisible.**The symbols that
  once populated the glyph table were deleted rather than escaped during a non-ASCII sweep, and
  `ggswim::scale_marker_discrete()` therefore drew nothing for every labelled event. Restored as
  print-safe geometric symbols ( ) that survive PDF and Word export. Glyph pattern
  matching was tightened at the same time so that short patterns match as whole words -- a bare "ct"
  had been matching "Infarction" and "Reaction".
- **Adding a milestone wiped the CR/PR/SD/PD colouring from the whole figure.**Mapping milestones to
  `color` added a second `scale_color_manual()` containing only milestone names; ggplot2 permits one
  colour scale per plot, so it replaced the lane scale and every response category fell through to
  `NA` grey. Milestones are now mapped to shape only.
- **A custom reference line crashed the plot on an absolute date scale.**lubridate does not export
  `months()` (`months` is a base generic), so `lubridate::months()` threw -- and months is the default
  time unit, so this killed the plot out of the box. The Period constructors also reject fractional
  amounts while `customReferenceTime` is an unconstrained number, so 12.5 crashed too. Now built with
  `lubridate::duration()`.
- **The copy-ready manuscript text asserted an objective response rate of 0.0% where the metrics table
  declined to make the claim.**ORR and DCR are defined only for RECIST-coded responses; with codings
  such as "Responder", 0/1 or "Grade 1" nothing normalises to CR/PR/SD/PD and the numerator is
  legitimately zero, which read as a genuine ORR of 0.0% with an exact binomial interval attached. The
  guard existed in one place only; both now go through one shared helper.
- **The summary table could show a median follow-up outside its own range.**The observed range was
  printed beside the reverse Kaplan-Meier median rather than the observed one. The estimator is now
  named, and the range stays attached to the observed median.
- **Rows excluded before validation were never disclosed.**`.validateClinicalData()` ran on the
  already-filtered frame, so its "these will be excluded" warnings could not fire for the rows an
  earlier filter had dropped; those patients disappeared from the figure and from every denominator
  with nothing said.
- **The plot and milestone table did not clear on `maxMilestones` or the milestone name options, and
  the export tables did not clear on `timeDisplay` or `timeUnit`.**
- **The ggswim fallback subtitle always read "ggswim unavailable" instead of the real error.**The
  helper signature is `(patient_data, milestone_data, event_data, opts, stats, error_message)`, and
  the error was being passed positionally into `milestone_data`, where it was discarded.

### Diagnostic Test Meta-Analysis (`diagnosticmeta`)

- **Deeks' funnel-plot asymmetry test was specified incorrectly and could report "no asymmetry" where
  Deeks' own specification finds it.**The effective sample size must be `4.n1.n0/(n1+n0)`, the
  regression of log diagnostic odds ratio on `1/sqrt(ESS)` must be weighted by ESS, and the slope
  referred to a *t* distribution on *k* - 2 degrees of freedom; the code used inverse-variance weights
  and a normal reference. The accompanying funnel plot has been switched to log DOR against
  `1/sqrt(ESS)` so that plot and test show the same thing -- it previously drew the conventional
  Egger-style precision axis, which Deeks et al. showed is misleading for diagnostic accuracy data
  because log DOR and its standard error are intrinsically correlated, so a visibly symmetric funnel
  could sit beside a significant asymmetry p-value (Deeks, Macaskill & Irwig 2005, *J Clin Epidemiol*
  58:882-93).
- **A single missing cell count aborted the entire analysis, and negative counts were dropped in
  silence.**The pre-exclusion study count was computed but never used, so the reported number of
  studies was the post-exclusion count with no indication that anything had been removed. Unusable
  studies -- missing or negative cells, or no diseased or no non-diseased participants -- are now
  excluded explicitly and listed.
- **The zero-cell option "None" applied a heavier correction than either option that advertises
  one.**`mada`'s default `correction.control = "all"` adds 0.5 to all four cells of *every* study as
  soon as one zero cell appears anywhere; "None" now sets `correction.control = "single"`, so only the
  affected studies are corrected. The disclosure block was also gated on the method not being "none",
  making it the one setting that said nothing. The option is retitled "None (correct only zero-cell
  studies)".
- **Meta-regression was guarded on the number of studies rather than on residual degrees of freedom.**
  A four-level covariate on five studies leaves none: `metafor` silently drops redundant predictors
  and the table then looks normal while describing a different model. Rows are also labelled with the
  user's covariate name -- the model is fitted on an internal column literally named `covariate`, so
  they had read "covariate", "covariateB", and so on.
- **Warnings were written into a panel that `.run()` had already hidden** as soon as all five
  variables were chosen, so a missing cell produced a completely blank analysis with no explanation
  anywhere on screen.
- **Study-level sensitivity and specificity were shown as proportions while the pooled table showed
  percentages** -- 0.82 next to 81.59 for the same quantity on one screen. Per-study values are now
  percentages to one decimal place.
- **The forest and SROC plots did not clear on `method`, `bivariate_analysis` or
  `confidence_level`, and the SROC region legend said "95%" unconditionally**, which became wrong once
  the ellipse started honouring the chosen confidence level. The legend now names the actual level and
  identifies the region as a confidence region for the summary point.

### IHC Heterogeneity (`ihcheterogeneity`)

- **The variance decomposition reported quantities that were not components of a common total.**On a
  20-case example the between-case row read 102.3% of total and the three percentages summed to
  107.5%, under a row explicitly labelled "Sum of all variance components". Replaced with a balanced
  two-way random-effects model -- sigma^2case = (MScase - MSerror)/k, sigma^2method = (MSmethod - MSerror)/n,
  sigma^2error = MSerror -- fitted on the cases measured by every method, with that number reported and any
  negative estimate truncated at zero and disclosed.
- **The intraclass correlation was not computed by the route the output claimed.**The table reported
  ICC(2,1) absolute agreement; the calculation did not match that definition. Now computed with
  `psych::ICC`, with the consistency form reported alongside absolute agreement -- the two differ
  exactly when there is a systematic offset between methods, which is the case worth seeing.
- **Reliability rows were labelled with a statistic that had not necessarily been computed.**Five
  fallback paths return the mean Spearman correlation, and that value was printed under the ICC
  heading and graded against ICC reliability cut-offs. The label now names the statistic actually
  used.
- **The per-case coefficient of variation had two definitions on one screen.**The table computed it
  from the regional columns alone while the interpretation folded in the reference measurement, so a
  single run could read "Mean CV = 23.19 / High variability", "moderate (mean CV = 20%)" and
  "ADEQUATE SAMPLING" together. Excluding the reference section also made a systematic under-read
  invisible: a 30% under-read appeared as 1.2% variability. One definition is now shared by the table
  and the narrative, and it includes the reference measurement when one exists.
- **Paired t-tests aborted the analysis when the difference vector had zero variance.**
  `t.test(paired = TRUE)` errors with "data are essentially constant", which is routine when scores are
  binned to whole percentages and every case shows the same offset. It was unguarded in four places.
- **The correlation power calculation counted rows with a missing reference measurement.**Using the
  length of the reference column rather than the number of complete pairs made `se_z = 1/sqrt(n - 3)`
  too small, so every reported power was inflated and every required sample size understated.

## Added

- **`waterfall`: three new display options.**`showCategoryLabels` prints the response category above
  each bar, `showSpiderLabels` puts the patient ID at the end of each spider line, and
  `annotationVars` draws covariate tracks beneath the bars. The annotation-track figure design is
  credited in code to Jamovi-TrialPlots by highwindmx (LGPL); this is an independent implementation.
- **`diagnosticmeta`: a prediction interval for a future study**, shown as a note on the bivariate
  table with a matching prediction region on the SROC plot. The pooled estimate and its confidence
  interval describe how well the *average* is known and say nothing about consistency across studies;
  the interval is built from the same quantity `mada` uses for its prediction region, so note and plot
  agree. A heterogeneity warning accompanies it.
- **`ihcheterogeneity`: relative bias** reported alongside the per-case coefficient of variation.
- **`R/recist_engine.R`**, an internal lesion-level RECIST v1.1 assessment engine covering target
  lesion selection and validation, target sums, new-lesion detection, non-target assessment, overall
  visit response, confirmation and best overall response. All of it is internal and unexported, and no
  shipped analysis calls it yet; it is infrastructure for the lesion-level analyses described in the
  `waterfall` documentation as coming in a future release.

## Changed

- **`waterfall` is now titled "Treatment Response: Patient-Level Burden"**, with the description
  rewritten to state explicitly that this is *not* a RECIST v1.1 implementation: because the analysis
  never sees individual lesions it cannot sum target lesions, detect new lesions, judge non-target
  progression, or apply the four-week confirmation rule. The summary table is retitled "Response
  Categories (threshold-based, not full RECIST v1.1)" and the menu subtitle changed from "Waterfall
  Plot, Spider Plot" to "One burden value per patient or visit".
- **`swimmerplot`: "Export Timeline Data" and "Export Summary Statistics" changed from `type: Output`
  to `type: Table`.**An `Output` result item writes a single computed column back into the dataset and
  must be bound to a matching `type: Output` option -- there was none, and the backend called
  `setState()` rather than `setRowNums()`/`setValues()`. Neither payload is a per-row column anyway:
  one is a multi-column frame, the other is one row per metric.
- **`diagnosticmeta`: performance claims in the interpretation text are now qualified by the
  confidence interval.**A pooled sensitivity of 90.4% with a 95% CI of 71-97% had been reported as
  "excellent ... will detect 90 out of 100 patients". The previously unlabelled p-value column on the
  sensitivity and specificity rows is now named for what it tests -- the Wald test of the logit
  intercepts (H0: sensitivity = 50%, H0: false-positive rate = 50%), which is trivially significant for
  any usable test.
- **`ihcheterogeneity`: multiplicity is disclosed** for the up to five unadjusted paired comparisons,
  and a statistically significant sampling bias must now also exceed 5% of the reference mean before it
  vetoes the adequacy verdict -- 5% being the "Minimal (<5%)" band the sampling-bias table already uses
  for clinical impact.

## Removed

- **`waterfall`: post-hoc statistical power reporting.**Observed power is a re-expression of the
  p-value and restates the test result rather than informing it (Hoenig & Heisey 2001); users planning
  a study are pointed to the Group-Sequential Design & Sample Size analysis instead.

## Note

- The lesion-level RECIST analyses that consume the new engine are still in development and are not
  part of this module; only the internal engine ships here.
- The review pass carried out this release also covered analyses in `meddecide`. **No file shipped in
  this module was affected by that work.**

# OncoPath 1.0.2 (2026-08-03)

## Fixed

- **Analysis variables were required arguments of the R function.**An option with no default in
  its jamovi definition compiles to a bare parameter, so calling the analysis from R without it
  failed with `argument "X" is missing, with no default` before the analysis's own validation
  could produce a usable message. Now defaulting to `NULL`: `diagnosticmeta` (`study`,
  `true_positives`, `false_positives`, `true_negatives`, `false_negatives`), `ihcheterogeneity`
  (`biopsy1`) and `waterfall` (`patientID`, `responseVar`). Behaviour in the jamovi GUI is
  unchanged; no statistical method was altered.


## Note

- The pre-release review pass carried out this release covered the survival-family and
  diagnostic-decision analyses (`jsurvival`, `meddecide`) and a package-wide `format()` namespace
  fix in the umbrella package. **No analysis shipped here was changed** -- none of the affected
  files is distributed to this module.

## Added

- **Automated GitHub release (`.github/workflows/release.yaml`).**A push to the default branch
  touching `DESCRIPTION` or `jamovi/0000.yaml` cross-checks the two version strings, refuses to
  proceed if they disagree, and -- if the tag does not already exist -- tags `v<version>` and
  publishes a release whose notes are the matching section of this file.

# OncoPath 1.0.0 (2026-07-13)

## jamovi library readiness

* Aligned all four analysis versions and the module manifest at 1.0.0.
* Removed the unfinished clinical-preset and orphaned stage-migration code.
* Reduced references and dependencies to the analyses that actually ship.
* Replaced the misleading HSROC label with the implemented Holling
  proportional-hazards SROC model and corrected its parameter descriptions.
* Honored estimator and confidence-level selections in auxiliary `metafor`
  models, with finite-value guards for zero-cell studies.
* Hardened validation/error rendering and translation-ready message assembly.

# OncoPath 0.0.47 (2026-07-05)

## Changes

* Declared `data.table`, `htmltools`, `psych`, and `stringr` (used via `::` but previously undeclared) so they install reliably with the module.

# OncoPath 0.0.46 (2026-07-04)

This release rolls up all changes from 0.0.33 through 0.0.46 (intermediate
versions 0.0.38.1, 0.0.43, and 0.0.45). The headline themes are a
security/robustness hardening pass ahead of a jamovi-library refactor
(HTML/XSS escaping of user-supplied text and error messages across every
analysis, removal of an unreliable variable-name mangling helper), migration of
the Swimmer Plot to a serialization-safe notices mechanism, a new suite of
exported stage-migration utility functions, new bundled example datasets, and
an upgrade of the module's minimum jamovi app and tooling requirements.

## Security & Robustness

### HTML/XSS Hardening (all analyses)
- **Diagnostic Test Meta-Analysis** (`diagnosticmeta`):
  - Wrapped error messages with `htmltools::htmlEscape()` in all five `tryCatch` handlers that write table notes: bivariate, HSROC, heterogeneity, meta-regression, and publication-bias analyses
  - Escaped the user-supplied meta-regression covariate label (`safe_covariate_label`) before it is written into the meta-regression results table
  - Escaped user-supplied study names in the zero-cell-correction warning note and HTML disclosure (`safe_studies_note`, `safe_studies_html`)
- **Swimmer Plot** (`swimmerplot`):
  - Escaped the best-response category in interpretation and manuscript-summary text
  - Escaped user-derived example values in the "Data Type Mismatch" and "Date Format Detected" guidance panels, and the detected date-format string
  - Escaped validation and analysis error messages before HTML interpolation
- **Treatment Response Analysis** (`waterfall`):
  - Escaped missing/available column names in the data-validation message
  - Escaped patient IDs lacking a baseline measurement, and the printed data-frame rows for invalid tumor-shrinkage and unusually-large-growth warnings
  - Replaced a bare `stop(plain_message)` with `jmvcore::reject("{}", code = NULL, plain_message)`
- **IHC Heterogeneity Analysis** (`ihcheterogeneity`):
  - Escaped the `spatial_id` variable name in the "not found in data" error message

### Variable-name Handling Bug Fix
- **`diagnosticmeta`**: removed the `.escapeVar()` helper, which mangled column names containing spaces or punctuation (e.g. `Study Name (2020)` became `Study_Name_2020_`) and then used the mangled string as a `self$data[[...]]` key, silently returning `NULL` and breaking the analysis. Study/TP/FP/FN/TN variables now use their raw option values as lookup keys.
- **`diagnosticmeta`**: narrowed package imports from `@import mada` / `@import metafor` to `@importFrom mada reitsma phm` and `@importFrom metafor rma`, and set `dontrun: true` on the analysis example.

### Output Cleanup
- Removed emoji from all HTML output panels (welcome/about/interpretation/glossary/plot-explanation panels, notice icons, and the Swimmer Plot clinical-event glyph mapping) across `diagnosticmeta`, `swimmerplot`, `waterfall`, and `ihcheterogeneity`, and replaced `%` with the word "percent" in `waterfall` and `ihcheterogeneity` option descriptions.

## Enhanced Existing Modules

### Swimmer Plot (`swimmerplot`) -- Notices Migration
- **NEW output** `notices` (type `Preformatted`, title "Important Information") with `clearWith` on `patientID`, `startTime`, `endTime`, `responseVar`, `censorVar`, and `timeUnit`
- Added `.noticeList`, `.addNotice()`, and `.renderNotices()` helpers that render plain-text notices via the Preformatted item, avoiding both the `jmvcore::Notice` serialization error and HTML in notice content
- Re-enabled the small-sample-size `STRONG_WARNING` (n < 10 patients), which was previously commented out to avoid serialization errors
- Emit an `ERROR` notice when required variables (Patient ID, Start Time, End Time) are missing
- Reset the notice list at the top of `.run()` to prevent accumulation across runs

## New Stage Migration Utility Functions

Four new R source files add an exported `stagemigration_*` helper suite (with man pages and `STAGEMIGRATION_CONSTANTS`) supporting staging-system comparison and validation:
- **Discrimination**: `stagemigration_calculateConcordance`, `stagemigration_bootstrapConcordance`, `stagemigration_competingRisksDiscrimination`
- **Competing risks & survival**: `stagemigration_competingRisksAnalysis`, `stagemigration_calculateRMST`, `stagemigration_cutpointAnalysis`
- **Data validation & quality**: `stagemigration_validateData`, `stagemigration_validateCovariates`, `stagemigration_validateStagingVars`, `stagemigration_createEventBinary`, `stagemigration_convertLabelled`, `stagemigration_detectOutliers`, `stagemigration_dataQualityReport`, `stagemigration_checkSampleSize`
- **Safe execution & formulas**: `stagemigration_safeAtomic`, `stagemigration_safeExecute`, `stagemigration_buildFormula`, `stagemigration_escapeVar`

### Shared Survival-Formula Helpers (`R/utils.R`)
- Added `.asSurvivalFormula()`, which wraps `jmvcore::asFormula` with an extended function allow-list for survival/Cox/Fine-Gray formula paths under jamovi 2.7.27's hardened parser
- Added `.buildSurvivalFormula()`, `.escapeVariableNames()`, `load_required_package()`, the `%notin%` / `%!in%` operators, and a `print.sensSpecTable` S3 method

## New Example Datasets

- **NEW** `R/data.R` documents five bundled datasets: `diagnostic_studies`, `histopathology`, `swimmerplot_sample`, `waterfall_percentage_basic`, and `waterfall_raw_longitudinal`
- **NEW** `.rda` files: `diagnostic_studies` (5 studies with `study_name`, `tp`, `fp`, `fn`, `tn`), `swimmerplot_sample`, `waterfall_percentage_basic`, and `waterfall_raw_longitudinal`
- **NEW** jamovi `.omv` versions under `inst/extdata/`: `swimmerplot_sample.omv`, `waterfall_percentage_basic.omv`, `waterfall_raw_longitudinal.omv`

## Dependencies

- Added `Imports`: `cluster`, `cmprsk`, `haven`, `maxstat`, `survRM2` (supporting the new competing-risks, RMST, cutpoint, and labelled-data utilities)
- Added `Depends: R (>= 3.5.0)`

## Package Infrastructure

- Bumped version 0.0.33 -> 0.0.46 (rolling up 0.0.38.1, 0.0.43, 0.0.45)
- Raised `minApp` from 1.6.0 to 2.7.27 to align with jamovi's hardened `as.formula` allow-list
- Migrated roxygen configuration from `RoxygenNote: 7.3.3` to `Config/roxygen2/version: 8.0.0`
- De-bracketed the `BugReports` URL in DESCRIPTION
- Added module audit report `docs/audit/MODULE_AUDIT_REPORT_20260514-1844.md`

---

# OncoPath 0.0.32.64 (2025-12-31)

## Major New Features

### Stage Migration Analysis Tools
- **NEW**: Comprehensive suite of statistical helper functions for stage migration analysis
- Advanced discrimination and reclassification metrics for comparing staging systems
- Designed for cancer staging research and prognostic model evaluation
- Supports survival analysis with Cox proportional hazards models

### Advanced Discrimination Metrics
- **Concordance Index (C-index)**: Paired comparison of staging system discrimination
- **Bootstrap Validation**: Robust C-index comparison accounting for data correlation
  - Configurable bootstrap replicates (default: 200)
  - Correlation-aware variance estimation for dependent staging systems
  - Automatic convergence handling and error recovery
- **Confidence Intervals**: Both analytical and bootstrap-based 95% CI estimation
- **Statistical Testing**: Two-sided hypothesis testing for C-index improvement

### Reclassification Metrics
- **Net Reclassification Improvement (NRI)**:
  - Time-dependent NRI calculation at multiple time points
  - Separate event and non-event reclassification statistics
  - Risk category-based patient stratification (tertiles by default)
  - Variance estimation with confidence intervals and p-values
- **Integrated Discrimination Improvement (IDI)**:
  - Discrimination slope comparison between staging systems
  - Bootstrap validation option for robust inference
  - Separate discrimination for events and non-events
  - Direct probability-based assessment

### Model Comparison Statistics
- **Information Criteria**: AIC and BIC for both staging systems with improvement metrics
- **Likelihood Ratio Tests**:
  - Combined model testing for incremental value
  - Individual model likelihood ratio statistics
  - Chi-square test statistics with degrees of freedom and p-values
- **Linear Trend Analysis**:
  - Wald tests for ordinal staging progression
  - Automatic handling of categorical and ordinal stage variables
  - Separate trend tests for old and new staging systems

### Pseudo R^2 Measures
- **Multiple Pseudo R^2 Variants**:
  - **McFadden R^2**: Log-likelihood ratio measure
  - **Adjusted McFadden R^2**: Penalized for model complexity
  - **Cox-Snell R^2**: Exponential transformation approach
  - **Nagelkerke R^2**: Normalized Cox-Snell (0-1 range)
  - **Royston R^2**: Placeholder for future implementation
- All measures calculated for both staging systems with improvement deltas
- Robust handling of edge cases (zero log-likelihoods, division by zero)

## Technical Improvements

### Statistical Robustness
- **Correlation-Aware Variance Estimation**:
  - Spearman correlation coefficient for linear predictor correlation
  - Covariance adjustment for paired C-index comparisons
  - Conservative variance bounds (non-negative constraint)
- **Bootstrap Methods for Correlated Data**:
  - Stratified sampling preserving event/non-event ratios
  - Percentile-based confidence intervals
  - Automatic outlier detection and removal
  - Progress checkpoint callbacks for long-running analyses

### Error Handling and Validation
- Comprehensive try-catch blocks throughout all functions
- Graceful degradation with informative error messages
- Automatic handling of:
  - Model convergence failures in bootstrap samples
  - Zero cells in contingency tables
  - Insufficient sample sizes
  - Missing or invalid data
- Validation of minimum sample requirements for reliable inference

### Flexible Staging System Support
- **Categorical Staging**: Nominal categories without ordering assumptions
- **Ordinal Staging**: Ordered stages with linear trend analysis
- **Mixed Systems**: Comparison between different staging paradigms
- Automatic detection of stage levels and appropriate statistical tests
- Support for varying numbers of stages between old and new systems

## Dependencies

### Updated Imports
- Enhanced `survival` package utilization for Cox models and concordance
- Extended `Hmisc` usage for survival correlation metrics (`rcorrp.cens`)
- `boot` package integration for bootstrap confidence intervals
- Comprehensive `stats` imports for statistical distributions and tests

## Internal Improvements
- Modular helper function architecture for maintainability
- Consistent naming conventions (`stagemigration_*` prefix)
- Progress callback support for computationally intensive operations
- Null coalescing operator (`%||%`) for default parameter handling
- Safe mathematical operations with bounds checking

## Use Cases

These stage migration tools are designed for:
- **Cancer Research**: Evaluating new TNM staging editions (e.g., AJCC 7th vs. 8th edition)
- **Prognostic Models**: Comparing traditional staging with molecular or imaging-based classifiers
- **Clinical Guidelines**: Evidence-based assessment of staging system updates
- **Meta-Research**: Systematic evaluation of staging system performance across studies
- **Quality Improvement**: Hospital-level assessment of staging accuracy and clinical impact

---

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
- **Swimmer Plot Analysis**: Timeline visualization with ggswim integration
- **Waterfall Plot Analysis**: RECIST criteria treatment response analysis
- Complete support for clinical trial reporting and oncological research

### Pathology Analysis Tools
- **IHC Heterogeneity Analysis**: Immunohistochemistry marker analysis
- **Diagnostic Test Meta-Analysis**: Bivariate meta-analysis with HSROC

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
