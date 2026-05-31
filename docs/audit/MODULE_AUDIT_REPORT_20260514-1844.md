# Module Audit Report — OncoPath 0.0.38.1

**Audited:** 2026-05-14 18:44 (Europe/Istanbul)
**Profile:** standard (security + jmvcore-migration + integration + notices + code-review)
**Functions audited:** 4 (declared in `jamovi/0000.yaml`) + 5 orphaned R helper files
**Repo:** `/Users/serdarbalci/Documents/GitHub/OncoPath`
**Skill:** audit-module v0.1.0

---

## Executive Dashboard

| Function | Status | HIGH-Sec | MEDIUM-Sec | LOW-Sec | i18n | Notices feature | Readiness |
|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| diagnosticmeta | NEEDS WORK | 2 (D-XSS) | 1 (D-XSS) | 3 | none (0 wraps) | none | Bivariate solid; HSROC mislabeled |
| ihcheterogeneity | NEEDS WORK | 0 | 0 | 3 | none (0 wraps) | none | Stats thoughtful; ICC type questionable |
| swimmerplot | NEEDS WORK | 3 (D-XSS) | 1 | 4 | partial (18 / 303) | declared, never populated | Math solid; XSS + dead notice infra |
| waterfall | NEEDS WORK | 0 | 2 (D-XSS via patient IDs) | 4 | partial (27 / 621) | canonical reference implementation | Strongest of the four; regulatory-use guard present |
| stagemigration-\*.R helpers | ORPHANED | — | — | — | — | — | 5 files of dead code (~2 480 lines) |

### Top cross-cutting issues

1. **Category D (HTML XSS) — affects 4/4 active functions.** 67 `setContent` calls module-wide, **0 uses of `htmltools::htmlEscape`**. Patient IDs, study labels, factor levels, and free-text option values are concatenated into HTML.
2. **i18n coverage gap — 2 of 4 functions have zero `.()` wrapping** (`diagnosticmeta`, `ihcheterogeneity`). The other two are partially wrapped (18 and 27 `.()` calls against 303 and 621 raw English literals). Module is not translation-ready.
3. **Notices feature underused — 3 of 4 functions bypass it.** `waterfall` is the canonical reference implementation. `swimmerplot` declares `errorNotice`/`infoNotice` containers in `.r.yaml` but never populates them and explicitly disabled the small-n warning. `ihcheterogeneity` and `diagnosticmeta` rely on ad-hoc HTML alert banners + `setNote`.
4. **`install.packages()` runs at package load** — `R/utils.R:49-50` calls `load_required_package("rlang")` and `load_required_package("magrittr")` as top-level executable code; the helper at line 40 calls `install.packages()`. Both packages are in `DESCRIPTION` Imports, so the helper is dead-but-dangerous: violates CRAN policy and would silently install code in any environment where `R/utils.R` is sourced but the imports were skipped.
5. **`clinicopath_startup_message()` is called at top level of `R/utils.R:621`** — every `library(OncoPath)` produces stdout side-effects. Should move to `.onAttach()` in a `zzz.R` if wanted at all.
6. **5 orphaned `stagemigration-*.R` files (~2 480 lines).** None of the 4 active analyses reference them; verified with grep across all `.b.R` files. They contain many `as.formula(paste(...))` patterns (Cat C1, currently safe but fragile). None of these helpers are exported in `NAMESPACE` (good), but they ride along on every install.
7. **Bulk `import()` directives in `NAMESPACE`** (`jmvcore`, `mada`, `metafor`, `ggswim`) instead of targeted `importFrom`. Pollutes namespace and inflates dependency surface.
8. **`.escapeVar()` is re-invented in every function** (`waterfall.b.R:3497`, `swimmerplot.b.R:484-area`, `ihcheterogeneity.b.R:22`, `diagnosticmeta.b.R:32`). In `diagnosticmeta` the helper actively breaks column lookup: `make.names("Study Name (2020)")` becomes `Study_Name_2020_`, which is then used as the key into `self$data[[...]]`, returning NULL.
9. **`asSource()` codegen quotes by hand** in `waterfall` (3542-3585) and `swimmerplot` (2913-2969). Manual ``paste0("`", name, "`")`` breaks on names containing `` ` ``, `"`, or `\` (per `MEMORY.md` `feedback_sourcify_quoting_correct_helper`).
10. **No formula-injection (Cat C1) finding in any active function.** All four functions avoid runtime formula construction in user-facing paths — a strong positive. The Cat C1 hits are confined to the orphaned `stagemigration-*` helpers.
11. **`R/utils.R` exports 13 helper functions that are never called by any active analysis** (`calculate_sensitivity`, `_specificity`, `_ppv`, `_npv`, `_plr`, `_nlr`, `_auc`, `raw_to_prob`, `validateROCInputs`, `bootstrapIDI`, `safe_divide`, `is_in_range`, `prop_to_percent`) plus a dead S3 method `print.sensSpecTable`. Operators (`%||%`, `%>%`, `%!in%`, `%notin%`, `%|%`) ARE used 130 times across the 4 main `.b.R` files — `utils.R` cannot simply be deleted.
12. **No Category A (runtime evaluation), Category E (system/source/download.file), Category F (deserialization), or `library()` in `R/`** anywhere in the active code or the orphans — the module's highest-risk pattern classes are clean.

---

## Methodology

**Profile:** standard

**Checks run:**

- Function discovery from `jamovi/0000.yaml` (4 entries) + `R/` filesystem cross-check
- Security pattern scan (catalog A through I, condensed)
- jmvcore migration scan (groups: formula | na | numeric | error | source)
- Integration audit (Argument Behavior, Output Population, Notices Coverage matrices)
- Notices coverage with clinical-threshold checklist
- Code review (8 areas, including i18n)

**Checks skipped:**

- External documentation comparison (CRAN/GitHub vignette parity) — run `/check-function-full <name>` per function if desired
- Function execution (differential runs) — heuristic only, no jamovi runs
- R CMD check, `devtools::document()`, `jmvtools::prepare()` — out of scope

**Audit-only.** No source files were modified.

---

## Per-Function Sections

### diagnosticmeta — NEEDS WORK

**File:** `R/diagnosticmeta.b.R` (2 379 lines)
**Surface area:** 22 options · 14 outputs (4 HTML, 6 Tables, 3 Images, 1 hidden) · `mada::reitsma` bivariate + `mada::phm` SROC + `metafor::rma` heterogeneity / meta-regression / Deeks.

**Executive summary.** Statistically thoughtful build on `mada` and `metafor` with Wilson CIs, delta-method LR/DOR CIs, Deeks effective-sample-size test, and an honest refusal to report univariate I² in the bivariate table. **Security posture is clean on the highest-risk categories** (no runtime evaluators, no string-built calls, no formula-string injection). Major gaps: (1) wide-open HTML XSS via unescaped study/covariate names in `setContent`, (2) no notices-feature usage, (3) HSROC table is actually `mada::phm` (Holling proportional-hazards SROC) and is mislabeled "HSROC Threshold (θ), HSROC Accuracy (Λ)" — these are Rutter-Gatsonis labels, **not** the parametrization `phm` returns, (4) no `.asSource()` for syntax export, (5) several `clearWith` lists omit `zero_cell_correction`, `color_palette`, and `confidence_level`.

**Security findings.**

| # | Cat | Sev | Location | Issue |
|---|---|---|---|---|
| 1 | D | HIGH | `R/diagnosticmeta.b.R:1649, 1761, 1888` | `.appendInstructionMessage()` and `setNote()` interpolate raw user-supplied study names into HTML via `sprintf("%s")` then push to `setContent`. Source: `private$.corrected_study_names` from `data[[study_var]]` (MEDIUM source) flowing into `setContent` (HIGH sink ⇒ escalates to HIGH). |
| 2 | D | HIGH | `R/diagnosticmeta.b.R:862, 884` | `metareg_table$addRow(..., parameter = covariate_var)` writes raw covariate column name into a table cell, and the same `covariate_var` flows into instruction HTML elsewhere. Tables coerce to text but HTML path is unescaped. |
| 3 | D | MEDIUM | `R/diagnosticmeta.b.R:222, 241, 253, 265, 277` | `setNote("error", sprintf('... %s', e$message))` — `e$message` can include arbitrary text from underlying packages. Table notes are typically rendered as plain text but worth confirming. |
| 4 | I | LOW | `R/diagnosticmeta.b.R:147, 174` | `as.numeric(data[[tp_var]])` then filtered by `>= 0`; NA values silently dropped. `original_n` is captured but `.validateStudyData` ignores it, so the discrepancy is never reported. |
| 5 | H | LOW | `R/diagnosticmeta.b.R:3-5` | `@import mada` and `@import metafor` (bulk) inflate NAMESPACE surface. |
| 6 | I | LOW | `R/diagnosticmeta.b.R:32` | `.escapeVar()` re-invents `make.names` + regex and the **escaped name is then used as `data[[study_var]]` key**, which silently breaks lookup for columns with spaces/dots in their names (e.g. `Study Name (2020)` → `Study_Name_2020_` → NULL). |

**jmvcore migration opportunities.**

| Group | File:line | Current → Replacement |
|---|---|---|
| `error` | `b.R:114, 151, 186` | `is.null(self$data)` checks + HTML alert via `setContent` → `jmvcore::reject(.("..."))` |
| `na` | `b.R:147` | manual `any(is.na(...) | ...)` → `jmvcore::naOmit` |
| `source` | — | **no `.asSource()` method present**; add one for R-syntax export |
| HTML-escape | 11+ `setContent` sites | wrap user-derived substrings with `htmltools::htmlEscape()` |

**Integration matrices.**

*Argument Behavior:* all 22 options wired. **Partial wiring** flagged for `confidence_level` (used in bivariate at b.R:357 and forest-plot Wilson CI at 968, **not** propagated to heterogeneity/meta-regression/HSROC), `method` (used by Reitsma only; heterogeneity/meta-regression hardcode `"REML"` at 739/829), `color_palette` (applied but **not in `clearWith`** for plot images), `zero_cell_correction` (applied in `.prepareAnalysisData` but **not in `clearWith`** for any table).

*Output Population:* `welcome` is defined+populated but `setVisible(FALSE)` everywhere (91, 116, 134, 140) — **dead output, remove**. `instructions` is overloaded as error sink + welcome + meta-regression missing-covariate notice + no-row-id failure.

*Notices coverage:* **no `jmvcore` Notice objects** (intentional per the serialization-fix comment at 13+ sites). Uses `table$setNote` + custom `.appendInstructionMessage` HTML. Missing clinical-threshold notices: studies < 4 (bivariate cannot estimate), AUC < 0.7, I² > 75%, zero cells with `correction = none`.

**Code review highlights.**

- **HSROC mislabeled.** `mada::phm` (b.R:592) is Holling proportional-hazards SROC, not Rutter-Gatsonis HSROC. Labels at `param_labels` 667-671 are misleading. Fix: rename to "Proportional Hazards SROC (Holling)" **or** add a true HSROC backend (`HSROC` package or Stan model).
- **`confidence_level` ignored by `metafor`** — heterogeneity, meta-regression, and HSROC tables silently use 95% even when user picks 90% or 99%.
- **Zero-cell handling with `correction = none`** — `var_logit_sens = 1/tp + 1/fn = Inf` silently propagates into `metafor::rma`. No `is.finite()` check.
- **SROC plot has no confidence/prediction region** — only the summary point.
- **`.escapeVar` lookup bug** (see Security #6).
- **i18n: zero `.()` wrapping.** All HTML literals, table notes, and error strings are raw English. Substantial work for `/prepare-translation`.

**Remediation pointer.** `/security-audit-function diagnosticmeta` → `/fix-notices diagnosticmeta` → `/review-function diagnosticmeta` (HSROC labeling, confidence_level propagation, AUC + prediction interval) → `/prepare-translation diagnosticmeta` → `/add-R-code diagnosticmeta` (missing `.asSource`).

---

### ihcheterogeneity — NEEDS WORK

**File:** `R/ihcheterogeneity.b.R` (2 230 lines) + `R/ihc_utilities.R` (306 lines, helpers largely unused)
**Surface area:** 19 options · 13 outputs (6 HTML, 7 Tables, 3 Images) · 16 private methods · reference-vs-biopsy and inter-regional analysis paths.

**Executive summary.** Mature and clinically thoughtful: dual study design (reference-based vs inter-regional), robust CV with safeguards, ICC(3,1) via `psych` with documented Fisher-z fallback, Hedges-corrected effect sizes, and a Fisher-z power calculation that is mathematically correct. Security surface is small — no formula codegen, no runtime evaluators, variable names go through `.escapeVar()`. Gaps: (1) one low-tier XSS via `self$options$spatial_id` unescaped into HTML, (2) **zero adoption** of `jmvcore::reject`/`naOmit`/`toNumeric`, (3) **no Notices feature usage** — all warnings/errors baked into HTML, (4) statistically: ICC(3,1) is used in reference-vs-biopsy comparisons where ICC(2,1) (agreement) would be more appropriate, and `.compareCompartments` passes a **single scalar** Spearman correlation to `.calculateICC`'s fallback which expects a vector.

**Security findings.**

| # | Cat | Sev | Location | Issue |
|---|---|---|---|---|
| 1 | D | LOW | `R/ihcheterogeneity.b.R:238` | `paste0("...'", self$options$spatial_id, "'...")` into `setContent` without `htmlEscape`. `spatial_id` is `Variable` type so practical risk is minimal but principle violated. |
| 2 | I | LOW | `R/ihcheterogeneity.b.R:1837` | `sum(cv_values > 50, na.rm = TRUE)` then `high_cv_cases > length(cv_values) * 0.2` — hardcoded `50` clashes with user-tunable `cv_threshold`. |
| 3 | I | LOW | `R/ihcheterogeneity.b.R:1810-1818` | `combined_data <- c(whole_section, as.matrix(biopsy_data))` mixes reference and regional scales for outlier detection. |

**jmvcore migration opportunities.**

| File:line | Current → Replacement |
|---|---|
| `b.R:172-176, 197-208, 237-241` | HTML "Error" via `setContent` + `return()` → `jmvcore::reject(.("..."))` |
| `b.R:904, 959, 1014` | `warning("ggplot2 package required...")` inside render → `jmvcore::reject` or silent `setNote` |
| `b.R` throughout | manual `!is.na()` filtering everywhere → `jmvcore::naOmit()` |
| `ihc_utilities.R:14-35` | custom `validateIHCData` returning list → `jmvcore::reject` in caller |

**Integration matrices.**

*Argument Behavior:* all 19 options wired, but `analysis_type=="reproducibility"` branch is undocumented (always runs reproducibility regardless), and `sampling_strategy=="random"` is informational only — no behavioral effect.

*Output Population:* `poweranalysistable` has a **visibility mismatch** — `.r.yaml` gates on `power_analysis` but backend computes when `analysis_type=="comprehensive"` too (b.R:383), so rows may be populated but hidden.

*Notices coverage:* **no Notices feature used at all.** All errors/warnings are HTML banners via `setContent`. Clinical-threshold gaps: ICC < 0.5, inter-region correlation < 0.4, n < 30 cases, > 20% missing data — none raise structured notices.

**Code review highlights.**

- **ICC type choice questionable.** Uses ICC(3,1) (consistency, two-way mixed) but the reference-vs-biopsy comparison binds `whole_section` (reference) as a column alongside biopsies — treating the reference as a "rater". ICC(2,1) (agreement) is more appropriate for reference-vs-biopsy. ICC(3,k) or simple Pearson for consistency among biopsies.
- **`.compareCompartments` scalar-vs-vector bug** (b.R:1908-1910). `region_correlations` is `cor(ref, rowMeans(biopsies))` — a scalar — but `.calculateICC`'s Fisher-z fallback treats it as a vector of correlations and averages it. When `psych` is unavailable the per-compartment ICC silently degrades to the case-mean correlation (different statistical meaning).
- **`.calculateRobustCV` not used consistently** — call sites at b.R:863, 972, 1042, 1939, 2116 compute `sd/mean*100` without the same near-zero guards.
- **Fisher-z fallback labeled as ICC(3,1)** in `reproducibilitytable` (b.R:531) — misleading. Title should change to "ICC(3,1) approximated via mean correlation".
- **`<<-` inside tryCatch** at b.R:1790-1791 — code smell.
- **i18n: zero `.()` wrapping.** 206 raw English strings in `.b.R`.

**Remediation pointer.** `/fix-notices ihcheterogeneity` → `/security-audit-function ihcheterogeneity` (htmlEscape at 238) → `/jamovify-function ihcheterogeneity` (reject/naOmit/toNumeric + i18n) → `/review-function ihcheterogeneity` (ICC type, `.compareCompartments` fallback, CV consistency, `poweranalysistable` visibility).

---

### swimmerplot — NEEDS WORK

**File:** `R/swimmerplot.b.R` (2 970 lines)
**Surface area:** 35 options (3 required + 5 String milestone names + free-text `customReferenceDate`) · 17 outputs (1 plot, 6 tables, 6 HTML, 2 exports, 1 validation report, 1 instructions) · ggswim integration.

**Executive summary.** Mathematically solid (reverse KM median follow-up, person-time merge-and-sum, exact binomial CIs, Fisher's exact group comparison) and clinically thoughtful (RECIST best-response hierarchy, group ORR/DCR). However it has a clear **HIGH-severity XSS surface**: free-text String options (`milestone1Name`-`milestone5Name`, `customReferenceDate`) and user-controlled response levels / event labels are interpolated into HTML via `paste0`/`sprintf` and pushed to `setContent` with no `htmlEscape`. There are no jmvcore migrations in place — every error path uses base `stop()`. Three Notice containers are declared (`errorNotice`, `infoNotice`, `warningNotice`) but only `warningNotice` is ever populated, and a planned small-sample warning is explicitly disabled (b.R:1342).

**Security findings.**

| # | Cat | Sev | Location | Issue |
|---|---|---|---|---|
| 1 | D | HIGH | `R/swimmerplot.b.R:1488-1527, 1533-1573` | `paste(validation_result$examples, collapse = "</code>, <code …>")` injects raw cell values from user-selected variables into HTML via `setContent`. Cell content like `<script>` would render. |
| 2 | D | HIGH | `R/swimmerplot.b.R:1216-1220, 1267-1272, 1274-1278, 2810-2814` | `sprintf("…%s…", best_response, …)` where `best_response` is a `names(stats$response_counts)` value — a user response factor level — pasted into clinical-summary / interpretation / copy-ready HTML. Factor level named `<img src=x onerror=…>` would execute. |
| 3 | D | HIGH | milestone1Name…milestone5Name → table cells | Free-text String options (HIGH source) flow into `milestoneTable` cells. Tables are safer than HTML containers but tier-up rule still applies — escape on principle. |
| 4 | C3 | LOW | `R/swimmerplot.b.R:2913-2969` | `asSource()` quotes variable names with hand-rolled ``paste0("`", name, "`")`` — breaks on names containing `` ` ``, `"`, `\`. Use `jmvcore::composeTerm` + `deparse()`. |
| 5 | H | LOW | `R/swimmerplot.b.R:1473` | `debug_mode <- getOption("swimmerplot.debug")` is set but never used. Dead probe. |
| 6 | I | LOW | `R/swimmerplot.b.R:856-865` | `min(df$start_time, na.rm = TRUE)` on Date/mixed objects — when all NA returns `Inf` with a warning. `is.finite(as.numeric(...))` does catch it but the typed `tibble` assignment downstream can coerce unpredictably. |

**jmvcore migration opportunities.**

| Group | File:line | Current → Replacement |
|---|---|---|
| `error` | `b.R:1593, 1734` | `stop(validation_result$message)` / `stop(e)` → `jmvcore::reject(...)` |
| `error` | `b.R:599, 2317, 2329` | `warning(paste(...))` → route via `warningNotice` HTML or `jmvcore::reject` for fatal |
| `numeric` | `b.R:233, 334, 335` | `as.character` + `as.numeric` of factor times → `jmvcore::toNumeric` |
| `source` | `b.R:2917-2968` | manual `asSource()` quoting → `jmvcore::composeTerm` + `deparse()` |

**Integration matrices.**

*Argument Behavior:* all 35 options wired. **Dead code:** `.applyClinicalPreset` (b.R:1369-1422) + `.preset_context` + `.preset_guidance` are commented-out logic (~100 lines of cruft).

*Output Population:* **`errorNotice`** and **`infoNotice`** are declared in `.r.yaml` but **never populated**. Only `warningNotice` is used (Fisher low-cell count at b.R:2200). Dead containers.

*Notices coverage:* `.addClinicalProfileNotices` (b.R:1342) is **entirely disabled** (body commented out). **No n < 10 warning is emitted.** No info notice when censoring is not provided (users get heuristic ongoing-status detection at b.R:538-545 without being told).

**Code review highlights.**

- **HTML template duplication** — `.generateInstructions`, `.displayClinicalSummary`, `.generateClinicalGlossary`, `.generateCopyReadyReport`, `.generateAboutAnalysis` total ~700 lines of HTML literals.
- **Date-parsing duplication** across `.validateAndProcessData` (296-336), `.processMilestones` (433-477), `.processEventMarkers` (637-679) — three near-identical "detect YYYY-MM-DD, parse, convert to relative" blocks. Should be one helper.
- **Double-error path** at b.R:1593+1719: `stop(validation_result$message)` inside `tryCatch` that re-prints the same error to `instructions`. User sees the error twice.
- **`stop(e)` re-raises the condition object** (b.R:1734), not its message — may break protobuf serialization.
- **Reverse Kaplan-Meier** for median follow-up (1086-1137): correct (Schemper & Smith 1996).
- **Fisher's exact** for group ORR/DCR: correct with low-cell warning.
- **i18n: partial.** 18 `.()` wraps against 303 raw strings. HTML templates (export-info L2256-2264, glossary L2710-2755, copy-ready L2823-2839, about-analysis L2843-2910) are all unwrapped.

**Remediation pointer.** `/security-audit-function swimmerplot` (S1-S3 XSS) → `/fix-notices swimmerplot` (wire `errorNotice`/`infoNotice`, re-enable small-n warning) → `/jamovify-function swimmerplot` (`reject`, `composeTerm`/`deparse` for asSource) → `/prepare-translation swimmerplot` → manual cleanup of dead `.applyClinicalPreset` block.

---

### waterfall — NEEDS WORK

**File:** `R/waterfall.b.R` (3 587 lines) + `jamovi/js/waterfall.events.js` (~190 lines)
**Surface area:** 6 tables (summary, clinicalMetrics, personTime, enhancedClinicalMetrics, groupComparisonTable, groupComparisonTest) · 10 HTML panels · waterfall + spider Image outputs · RECIST-category Output variable · notices HTML (canonical reference implementation).

**Executive summary.** This is the strongest of the four functions and the reference implementation for the notices-to-HTML pattern (per `CLAUDE.md`). Authors have already done substantial defensive work: `.safeHtmlOutput` helper, `.escapeVar` for column-access, exact-binomial and bootstrap CIs, REGULATORY USE PROHIBITED Notice, single-lesion limitation Notice, and the html-based Notices system (`.addNotice`/`.renderNotices`) at end of `.run()`. No code-execution sinks were found (no runtime evaluators, no `do.call(var)`, no `match.fun`, no `as.formula`, no `system`, no `source`). The remaining work is: (1) unescaped HTML interpolation of patient IDs in invalid-shrinkage / large-growth tables, (2) `clinicalPreset` dead-option mismatch between `waterfall.events.js` and `waterfall.a.yaml`, (3) a custom `.calculateStatisticalPower` formula that diverges from the textbook power-for-proportions, and (4) `personTimeTable`'s "rapid/standard/delayed" classification (≤2 / ≤6 / >6) with no time-unit awareness.

**Security findings.**

| # | Cat | Sev | Location | Issue |
|---|---|---|---|---|
| 1 | D | MEDIUM | `R/waterfall.b.R:843-858, 861-876` | `paste(capture.output(print(invalid_shrinkage)), collapse="<br>")` and same for `large_growth` embed raw patient IDs (from a Variable option) into HTML via `self$results$todo2$setContent(...)`. `print(data.frame)` is plain text but is then concatenated into HTML without escaping. Patient IDs (MEDIUM source) into HTML sink (HIGH) gives effective MEDIUM. |
| 2 | D | MEDIUM | `R/waterfall.b.R:814-815` | `paste(patients_without_baseline, collapse=", ")` interpolated into HTML without `.safeHtmlOutput`. |
| 3 | H | LOW | `jamovi/js/waterfall.events.js:3, 86, 107, 124, 184` | `ui.clinicalPreset.value()` referenced in 5 handlers but `clinicalPreset` is commented out at `waterfall.a.yaml:127`. Reading a non-existent UI option throws at runtime, breaking the events file. |
| 4 | I | LOW | `R/waterfall.b.R:802-809, 1210-1240` | `dplyr::summarise(has_baseline = any(.data[[timeVar]] == 0))` — exact equality `== 0` on floating-point silently misclassifies baselines encoded as `0.0001`. |
| 5 | I | LOW | `R/waterfall.b.R:3505` | `make.names(x)` + `gsub("[^A-Za-z0-9_]+", "_", safe_name)` is used as the only sanitizer; `safe_name` then keys `dplyr::select(!!rlang::sym(safe_name))`. Names with spaces (`Patient ID` becoming `Patient_ID`) won't exist in `self$data`. Works today only because jamovi pickers normally pre-sanitize. |

**jmvcore migration opportunities.**

| Group | File:line | Current → Replacement |
|---|---|---|
| `error` | `b.R:1544` | `stop(plain_message, call.=FALSE)` → `jmvcore::reject(plain_message)` |
| `error` | `b.R:510, 1831, 2254, 2450, 2586, 2594, 2616, 2805, 3135, 3139, 3147` | `warning(...)` for user-visible conditions → route via `.addNotice("WARNING", ...)` (infra already exists) |
| `format` | ~60 sites | `sprintf(.("...%d..."), n)` → `jmvcore::format(.("...{}..."), n)` |
| `source` | `b.R:3542-3585` | hand-rolled backtick quoting in `asSource()` → `jmvcore::sourcifyOption("responseVar")` or `deparse(responseVar)` |
| `numeric`, `formula`, `na` | — | already correctly using `jmvcore::toNumeric`; no formula construction; uses `dplyr::filter(!is.na(...))` |

**Integration matrices.**

*Argument Behavior:* all options wired except `clinicalPreset` (declared in `events.js` but commented out in `.a.yaml`) — this is the runtime JS error noted in Security #3.

*Output Population:* all outputs populated correctly, with conditional gates. `personTimeTable` is conditional on `timeVar` + `inputType == "raw"` (good). `groupComparisonTest` is conditional on `groupVar` AND ≥2 groups (good).

*Notices coverage:* **canonical implementation.** Uses html-Notices pattern (`.addNotice`/`.renderNotices`) end-to-end. Emits ERROR (regulatory-use blocker), STRONG_WARNING (RECIST limitations, very-small-sample, wide CI), WARNING (single-lesion, no confirmation, TTE limitations, extreme values, small sample 10-20), INFO (baseline assumption). Clinical thresholds: n < 10 → STRONG_WARNING, n < 20 → WARNING, CI-width > 40pp → STRONG_WARNING.

**Code review highlights.**

- **Duplicated plot logic.** `.waterfallplot` renderFun (2245-2480) duplicates the helpers `.prepareWaterfallPlotData`, `.getColorSchemes`, `.selectWaterfallColors`, `.createWaterfallBasePlot`, `.addRecistThresholds`, `.addResponseLabels`, `.addMedianAndCI` (297-481). Pick one and delete the other.
- **Three near-identical raw-data paths** — `.processRawDataStandard` (550), `.processDataStandard` (627), `.processData` (991). Consolidate.
- **3 587 lines** — split into validate / process / render / report files.
- **`.calculateStatisticalPower`** (145) uses a non-standard "h minus z_alpha*se / se" approximation that is not the textbook power-for-proportions formula. Today it produces a number interpreted to "Adequate/Moderate/Low" — wrong values shape the displayed verdict. Replace with `pwr::pwr.p.test` or textbook form.
- **`personTimeTable` rapid/standard/delayed** uses hardcoded `≤2 / ≤6 / >6` cutoffs with no time-unit awareness — a study in days always says "rapid". Either scale by `timeUnitLabel` or disable when `generic`.
- **`set.seed(123)` at b.R:2414** — collides with user RNG state. Use `withr::with_seed(123, …)` or save/restore `.Random.seed`.
- **i18n: best of the four** — 27 `.()` wraps. Remaining unwrapped: notice titles ("REGULATORY USE PROHIBITED", "RECIST COMPLIANCE LIMITATION"), `"EXTREME VALUES DETECTED: "` at 1655. Most table content and HTML body strings are wrapped.

**Remediation pointer.** `/security-audit-function waterfall` (#1, #2 patient-ID escaping; #4 float-equality) → `/fix-function waterfall` (remove duplicate plot helpers OR refactor render to use them; restore-or-strip `clinicalPreset` to fix events.js error) → `/jamovify-function waterfall --apply` (`reject` at 1544; `sprintf` → `jmvcore::format`; clean `asSource`) → `/review-function waterfall` (textbook power formula; time-unit-aware rapid/standard/delayed) → `/prepare-translation waterfall` (notice titles + remaining bare strings).

---

### Orphaned files — stagemigration-\* helpers (ORPHANED-IMPLEMENTATION)

**Files (5 helpers, ~2 480 lines total):**
- `R/stagemigration-competing-risks.R` (524 lines)
- `R/stagemigration-discrimination.R` (301 lines)
- `R/stagemigration-utils.R` (570 lines)
- `R/stagemigration-validation.R` (521 lines)
- `R/stagemigration_helpers.R` (563 lines)

**Verified orphan status.** `grep "stagemigration_\|stagemigration-"` across all four `.b.R` files returns **zero references**. These helpers are entirely dead code in the OncoPath module — no analysis declares a `stagemigration` entry in `jamovi/0000.yaml`, and no `R/stagemigration.b.R` exists. They appear to be a partial copy from the parent ClinicoPath module where the main analysis file was omitted.

**Security in dead code.** Even unreferenced, package code is loaded at `library(OncoPath)`. The orphans contain **11 occurrences of `as.formula(paste(...))`** (Category C1) — e.g. `R/stagemigration_helpers.R:16-17, 109, 164-165, 336-337, 438-439` and `R/stagemigration-utils.R:298, 315`. The construction interpolates user-provided `time_var`, `event_var`, `old_stage`, `new_stage` after manual backtick wrapping; there is no `jmvcore::asFormula` allow-list guard. Currently unreachable (no caller). The cleaner refactor in `stagemigration-utils.R::stagemigration_buildFormula` does proper `make.names` + regex + backtick wrapping, but `stagemigration_helpers.R` (the older predecessor) does NOT use it — confirmed by header comment in `stagemigration-discrimination.R:7`: *"Source: Functions moved and refactored from stagemigration_helpers.R."*

**NAMESPACE export.** None of the `stagemigration_*` functions are exported. They are loaded into the package namespace at install time and visible only via `OncoPath:::stagemigration_*` (triple-colon).

**`R/utils.R` (620 lines) — separate issue: runtime side-effects.**

- `R/utils.R:49-50` — **top-level executable code that triggers `install.packages()` transitively**:
  ```r
  load_required_package("rlang")
  load_required_package("magrittr")
  ```
  The helper at `R/utils.R:40` calls `install.packages(package_name)` when `requireNamespace` fails. Both `rlang` and `magrittr` are already in `DESCRIPTION` `Imports:`, so this code is dead-but-dangerous: it violates CRAN policy (a package must not auto-install dependencies) and would silently install code in any environment where `R/utils.R` is sourced but the imports failed.
  **Action:** delete the `load_required_package` helper and its two top-level invocations. If dependency loading needs explicit handling, do it inside a function that's called from `.run()` and uses `requireNamespace(..., quietly=TRUE)` only.

- `R/utils.R:621` — `clinicopath_startup_message()` is called at **top level**. Every `library(OncoPath)` prints to stdout (and likely doubles up with `.onAttach()` if defined elsewhere). Move to `.onAttach()` in a dedicated `zzz.R` if wanted at all.

- **Operators ARE used:** `%>%`, `%||%`, `%!in%`, `%notin%`, `%|%` — 130 hits across the 4 main `.b.R` files. `utils.R` must be kept, not deleted; refactor instead.

- **Dead exports:** the following are `@export`-tagged but never called from any OncoPath `.b.R`: `calculate_sensitivity`, `_specificity`, `_ppv`, `_npv`, `_plr`, `_nlr`, `_auc`, `raw_to_prob`, `validateROCInputs`, `bootstrapIDI`, `safe_divide`, `is_in_range`, `prop_to_percent`, `load_required_package`, `clinicopath_startup_message`. The S3 method `print.sensSpecTable` is registered in `NAMESPACE` but the `sensSpecTable` class is never constructed anywhere — dead S3 method.

**`R/00jmv.R` (2 210 lines).** Standard auto-generated jmv module loader / citation bundle. The header confirms it: *"This file is automatically generated, you probably don't want to edit this"*. The size is inflated because `jamovi/00refs.yaml` carries citations for parent-module analyses (`emmeans`, `afex`, `BF`, `sparsepca`, `kernlab`) that don't exist in OncoPath. Functionally harmless; cosmetic prune of `00refs.yaml` would shrink it.

**`R/data.R` (41 lines).** Documents 5 datasets (`diagnostic_studies`, `histopathology`, `swimmerplot_sample`, `waterfall_percentage_basic`, `waterfall_raw_longitudinal`). Only 3 are declared in `jamovi/0000.yaml` `datasets:`. Minor doc/yaml drift; consider exposing `diagnostic_studies` for end-user discoverability of `diagnosticmeta` sample data.

**`R/ihc_utilities.R` (306 lines).** Largely unused by `ihcheterogeneity.b.R` (which reimplements equivalent helpers inline). Either consolidate the `.b.R` against these helpers or remove the unused exports (`calculateHScore`, `validateIHCData`, `getIHCColorPalette`, `getIHCTheme`, etc.).

**Recommendation.**

1. **DELETE** all 5 `stagemigration-*` files (verified zero references). If the parent module's stagemigration analysis is intended to ship here later, restore them with the corresponding `stagemigration.b.R`, `.a.yaml`, `.u.yaml`, `.r.yaml` set in one commit — and prefer the cleaner refactored `stagemigration-utils.R` + `stagemigration-discrimination.R` over the legacy `stagemigration_helpers.R` (which has the Cat-C1 formula-construction debt).
2. **DELETE** `R/utils.R:37-51` (the `load_required_package` mechanism and its two top-level calls). Replace, if needed, with per-function `requireNamespace("pkg", quietly=TRUE)` guards inside `.run()`.
3. **MOVE** `clinicopath_startup_message()` invocation from `R/utils.R:621` to a `zzz.R` `.onAttach()` hook (or delete entirely).
4. **AUDIT** `R/utils.R` exports against actual usage in the 4 active `.b.R` files; keep only operators + functions intended as public API. Consider moving the unused ROC/sensitivity helpers back into their proper home in the parent ClinicoPath module.
5. **CONSOLIDATE** `R/ihc_utilities.R` against `ihcheterogeneity.b.R` (currently the b.R reimplements the helpers inline).
6. **REPLACE** bulk `import(jmvcore)`, `import(mada)`, `import(metafor)`, `import(ggswim)` in `NAMESPACE` with targeted `@importFrom` tags in roxygen; regenerate via `devtools::document()`.
7. **REMOVE** dead `S3method(print, sensSpecTable)` registration (`sensSpecTable` class never instantiated).
8. **RUN** `rm OncoPath_*.jmo` to clean the 5 stale `.jmo` build artifacts (~135 MB) from the repo root — they're git-ignored but cluttering the filesystem.

---

## Cross-Cutting Issues

### D-HIGH — HTML/XSS — 3 of 4 active functions

67 `setContent` calls module-wide; **0 uses of `htmltools::htmlEscape`** anywhere in `R/`. The pattern is consistent: user-derived strings (patient IDs, study labels, factor levels, free-text option values, validation examples) are pasted into HTML via `paste0`/`sprintf` and pushed to `self$results$<x>$setContent(...)`. Tables coerce to text and are safer; HTML containers are the live exposure.

**Affected functions:** `diagnosticmeta` (study names), `swimmerplot` (validation examples, response factor levels, milestone names), `waterfall` (patient IDs in invalid-shrinkage / large-growth tables).
**Reference fix idiom:** wrap user-derived substrings with `htmltools::htmlEscape()` before paste. `R/waterfall.b.R` has a `.safeHtmlOutput` private helper; promote it (or move into `R/utils.R`) and use it module-wide.
**Run per function:** `/security-audit-function <name>` then `/fix-function <name>`.

### Notices feature underused — 3 of 4 functions

- `waterfall` — canonical implementation (uses `.addNotice`/`.renderNotices`)
- `swimmerplot` — declares `errorNotice`/`infoNotice` containers but never populates them; the small-sample warning `.addClinicalProfileNotices` is explicitly disabled
- `ihcheterogeneity` — no notices at all; only HTML alert banners and `setNote`
- `diagnosticmeta` — no notices at all; only `setNote` + `.appendInstructionMessage` HTML

**Reference fix idiom:** `R/waterfall.b.R` `.addNotice` / `.renderNotices` private helpers + `.r.yaml` `notices: type: Html`.
**Run per function:** `/fix-notices <name>`.

### i18n coverage — 4 of 4 functions

| Function | `.()` wraps | Raw English strings (approx) |
|---|---:|---:|
| diagnosticmeta | 0 | 207 |
| ihcheterogeneity | 0 | 206 |
| swimmerplot | 18 | 303 |
| waterfall | 27 | 621 |

Module is not translation-ready.
**Run per function:** `/prepare-translation <name>`. Two functions need work from scratch; the other two need completion.

### jmvcore migration — 4 of 4 functions

Common patterns across the module:

- `stop()` in user-facing path → `jmvcore::reject()`
- `sprintf` → `jmvcore::format(..., context="R")` where relevant for `.asSource()`
- `setContent(<error HTML>) + return()` → `jmvcore::reject(...)`
- Manual backtick quoting in `.asSource()` → `jmvcore::composeTerm` + `deparse()`
- Manual `!is.na()` filtering on jamovi-attributed data → `jmvcore::naOmit`

**Run per function:** `/jamovify-function <name> --apply`.

### Package-level hygiene

1. **Runtime `install.packages()` in `R/utils.R:40, 49-50`** — must be removed (CRAN policy + package-load-time side effect). See "Orphaned files" section above.
2. **Top-level `clinicopath_startup_message()` call** at `R/utils.R:621` — move to `.onAttach()`.
3. **Bulk `import()` in NAMESPACE** for `jmvcore`, `mada`, `metafor`, `ggswim` — replace with targeted `importFrom` per the existing roxygen tags. `devtools::document()` will regenerate.
4. **5 stale `.jmo` build artifacts (~135 MB) in the repo root** — not git-tracked (verified) but cluttering the filesystem. The pattern `*.jmo` is in `.gitignore` (good) and `^.*\.jmo$` is in `.Rbuildignore` (good). Just `rm OncoPath_*.jmo` to clean the local checkout.
5. **`R/00jmv.R` is 2 210 lines** because `jamovi/00refs.yaml` carries refs from the parent ClinicoPath module that don't apply here. Cosmetic prune of `00refs.yaml` followed by `jmvtools::prepare()` would shrink it.
6. **`R/data.R` documents 5 datasets but `jamovi/0000.yaml` only declares 3 as sample datasets.** Consider exposing `diagnostic_studies` and `histopathology` if they're intended as user-facing samples.

---

## Remediation Playbook

**Priority 1 — HIGH security findings** (run these first; one approval gate per function):

- `/security-audit-function diagnosticmeta` — XSS via study names in `setContent` (3 sites)
- `/security-audit-function swimmerplot` — XSS via validation examples, response factor levels, milestone names (4 sites)
- `/security-audit-function waterfall` — patient-ID escaping in invalid-shrinkage / large-growth HTML (2 sites)

**Priority 2 — Critical statistical / clinical correctness:**

- `/review-function diagnosticmeta`:
  - Relabel "HSROC" → "Proportional Hazards SROC (Holling)" *or* add a true Rutter-Gatsonis backend
  - Propagate `confidence_level` to `metafor::rma` calls
  - Add `is.finite()` guard for `1/tp + 1/fn = Inf` when `zero_cell_correction = none`
  - Add SROC confidence region
- `/review-function ihcheterogeneity`:
  - ICC(2,1) vs ICC(3,1) decision for reference-vs-biopsy
  - Fix `.compareCompartments` scalar-vs-vector issue at b.R:1908-1910
  - Consolidate CV computations via `.calculateRobustCV`
  - Fix `poweranalysistable` visibility mismatch
- `/review-function waterfall`:
  - Replace `.calculateStatisticalPower` with textbook formula (`pwr::pwr.p.test`)
  - Add time-unit awareness to person-time rapid/standard/delayed thresholds
  - Switch `set.seed(123)` to `withr::with_seed(123, ...)`
- Manual: `swimmerplot` re-enable disabled `.addClinicalProfileNotices` small-sample warning

**Priority 3 — Module-wide hygiene:**

- `/fix-notices diagnosticmeta` (no notices yet)
- `/fix-notices ihcheterogeneity` (no notices yet)
- `/fix-notices swimmerplot` (wire `errorNotice`/`infoNotice`)
- `/jamovify-function <name> --apply` for each of the four
- `/prepare-translation <name>` for each of the four
- `/add-R-code diagnosticmeta` (missing `.asSource`)

**Priority 4 — Package cleanup (no skill, manual):**

1. **DELETE** the 5 `stagemigration-*` files (zero references, ~2 480 lines of dead code).
2. **DELETE** the `load_required_package` helper and its 2 top-level calls in `R/utils.R:37-51` (CRAN policy violation).
3. **MOVE** `clinicopath_startup_message()` invocation to `.onAttach()` in a new `zzz.R` (or delete entirely).
4. **AUDIT** `R/utils.R` exports against actual usage in the 4 `.b.R` files; keep only operators + true public API. The 13 unused exports (`calculate_*`, `raw_to_prob`, `validateROCInputs`, `bootstrapIDI`, `safe_divide`, `is_in_range`, `prop_to_percent`, `load_required_package`, `clinicopath_startup_message`) should either be deleted or moved back into the parent ClinicoPath module.
5. **CONSOLIDATE** `R/ihc_utilities.R` against `ihcheterogeneity.b.R` (currently the b.R reimplements the helpers inline).
6. **REPLACE** bulk `import()` in `NAMESPACE` with targeted `@importFrom` tags; regenerate via `devtools::document()`.
7. **REMOVE** dead `S3method(print, sensSpecTable)` registration (`sensSpecTable` class never instantiated).
8. **RUN** `rm OncoPath_*.jmo` to clean stale build artifacts from the repo root.
9. **PROMOTE** `.safeHtmlOutput` from `waterfall.b.R` into `R/utils.R` and use module-wide.

---

## Appendix: Methodology Notes

- Reference catalogs used: `.claude/skills/audit-module/references/security-patterns.md`, `.../jmvcore-migration.md`. Per-function audits were dispatched as 5 parallel subagents (one per declared analysis + one for the orphan inventory).
- Function file lengths: `waterfall.b.R` 3587, `swimmerplot.b.R` 2970, `diagnosticmeta.b.R` 2379, `ihcheterogeneity.b.R` 2230 — total 11 166 lines of `.b.R` across 4 analyses (mean 2 792). Plus 2 480 lines of orphaned `stagemigration-*` helpers and 620 lines of `R/utils.R`.
- Module-wide pattern counts: 67 `setContent` calls, 0 `htmlEscape`, 0 runtime evaluators, 0 `system`/`source`/`download.file`, 1 `do.call(<var>, ...)` (literal `do.call(rbind, lapply(...))` in `diagnosticmeta.b.R:1107` — safe).
- The single Category H risk is **`R/utils.R:49-50`** — `load_required_package("rlang")` and `load_required_package("magrittr")` at top-level, where the helper calls `install.packages()`.

---

*Generated by the `audit-module` skill (v0.1.0). Re-run with `/audit-module <path> --profile=deep` for R6 / R-package / vignette-cross-reference passes, or with `--functions=<name>` for a targeted re-audit.*
