# IHC Heterogeneity: How Much Does a Biopsy Tell You About the Tumor?

## The Question

A pathologist scores Ki-67 on a core biopsy, and the report carries that
number forward as though it described the tumor. It describes the core.
If the marker is heterogeneously expressed, a second core from the same
tumor may give a different answer. Regional differences can reflect
biological heterogeneity, sectioning, staining, image analysis and
scoring error. These data alone cannot separate those sources; repeated
technical measurements and a suitable study design are needed to
attribute variation to tumor biology.

`ihcheterogeneity` quantifies that gap. Give it a reference measurement
(whole section, or a hot-spot score) and one or more regional
measurements from the same cases. It reports how well the regions
reproduce the reference, whether they do so with a systematic offset,
and how much of the total variance is sampling rather than real
between-case difference.

This matters clinically wherever a threshold is applied to a single
sample: Ki-67 cut-offs in neuroendocrine tumors and breast cancer, PD-L1
scoring, quantitative (image-analysis) HER2 scores. A marker with high
within-tumor variability crossing a threshold on one core is not the
same finding as one that sits comfortably on one side of it.

## Data Layout

One row per case. One column for the reference measurement, one column
per region.

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`OncoPath`](https://www.serdarbalci.com/OncoPath/)`)`\
[`set.seed`](https://rdrr.io/r/base/Random.html)`(``11``)`\
`n`` ``<-`` ``40`\
`ihc`` ``<-`` `[`data.frame`](https://rdrr.io/r/base/data.frame.html)`(``CaseID ``=`` `[`sprintf`](https://rdrr.io/r/base/sprintf.html)`(``"C%02d"``, ``1``:``n``)``)`\
`ihc``$``Whole`` ``<-`` `[`round`](https://rdrr.io/r/base/Round.html)`(`[`pmin`](https://rdrr.io/r/base/Extremes.html)`(``100``, `[`pmax`](https://rdrr.io/r/base/Extremes.html)`(``0``, `[`rnorm`](https://rdrr.io/r/stats/Normal.html)`(``n``, ``45``, ``18``)``)``)``, ``1``)``   ``# whole-section Ki-67 %`\
\
`jitter_from`` ``<-`` ``function``(``mu``, ``sd``)`` `[`round`](https://rdrr.io/r/base/Round.html)`(`[`pmin`](https://rdrr.io/r/base/Extremes.html)`(``100``, `[`pmax`](https://rdrr.io/r/base/Extremes.html)`(``0``, ``mu`` ``+`` `[`rnorm`](https://rdrr.io/r/stats/Normal.html)`(``n``, ``0``, ``sd``)``)``)``, ``1``)`\
`ihc``$``Biopsy1`` ``<-`` ``jitter_from``(``ihc``$``Whole``, ``8``)``    ``# a well-sampled region`\
`ihc``$``Biopsy2`` ``<-`` ``jitter_from``(``ihc``$``Whole``, ``11``)`\
`ihc``$``Biopsy3`` ``<-`` ``jitter_from``(``ihc``$``Whole``, ``14``)``   ``# a poorly representative one`\
`ihc``$``Compartment`` ``<-`` `[`factor`](https://rdrr.io/r/base/factor.html)`(`[`rep`](https://rdrr.io/r/base/rep.html)`(`[`c`](https://rdrr.io/r/base/c.html)`(``"Tumor center"``, ``"Invasive front"``)``, each ``=`` ``n`` ``/`` ``2``)``,`\
`                          levels ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"Tumor center"``, ``"Invasive front"``)``)``   ``# for the compartment example`\
\
[`head`](https://rdrr.io/r/utils/head.html)`(``ihc``)`

`wholesection` is optional. Without it, the analysis compares every pair
of regions with each other. That answers “do two cores agree?” rather
than “does a core represent the tumor?”. It is a weaker question, but
the only one available when no whole-section score exists. Each pair’s
correlation then gets its own row and 95% CI, as each region does with a
reference.

## A Complete Run

\
`res`` ``<-`` `[`ihcheterogeneity`](https://www.serdarbalci.com/OncoPath/reference/ihcheterogeneity.md)`(`\
`  data         ``=`` ``ihc``,`\
`  wholesection ``=`` ``"Whole"``,`\
`  biopsy1      ``=`` ``"Biopsy1"``,`\
`  biopsy2      ``=`` ``"Biopsy2"``,`\
`  biopsy3      ``=`` ``"Biopsy3"``,`\
`  ``` # biopsy4 and `biopsies` take a fourth region and any number beyond that ``\
`  analysis_type            ``=`` ``"comprehensive"``,  ``# reproducibility | variability | comprehensive`\
`  sampling_strategy        ``=`` ``"random"``,         ``# random | systematic | stratified | unknown`\
`  cv_threshold             ``=`` ``20``,               ``# largest acceptable within-case CV (%), the root mean square of the per-case CVs`\
`  correlation_threshold    ``=`` ``0.7``,              ``# smallest acceptable Spearman correlation`\
`  bias_margin              ``=`` ``5``,                ``# largest acceptable systematic difference (% of the reference mean)`\
`  variance_components      ``=`` ``TRUE``,`\
`  sample_size_planning     ``=`` ``TRUE``,`\
`  generate_recommendations ``=`` ``TRUE``,`\
`  show_variability_plots   ``=`` ``TRUE`\
`)`

### Reproducibility

                                         metric  value ci_lower ci_upper                                                   interpretation
            Mean Regional-Reference Correlation  0.760    0.559    0.877                                     Meets your threshold (≥ 0.7)
     Spearman correlation: Biopsy1 vs reference  0.862    0.727    0.933                                     Meets your threshold (≥ 0.7)
     Spearman correlation: Biopsy2 vs reference  0.757    0.554    0.875                                     Meets your threshold (≥ 0.7)
     Spearman correlation: Biopsy3 vs reference  0.662    0.414    0.818                                     Below your threshold (< 0.7)
                  ICC(2,1) - absolute agreement  0.663    0.527    0.783                                             Moderate reliability
            ICC(3,1) - consistency (bias-blind)  0.658    0.521    0.779 Ignores systematic offset; compare with absolute agreement above
                Mean Inter-Regional Correlation  0.554       NA       NA                                     Below your threshold (< 0.7)
     Within-case CV (%) - reference and regions 30.934       NA       NA                                                 High variability
                         Median per-case CV (%) 23.178       NA       NA           Descriptive, robust to a few extreme cases; not graded

Each region is graded on its own. Biopsy3 (0.662) is below the 0.7
threshold as a point estimate, but its 95% CI reaches 0.818, so it is
not *shown* to be below it. A region shown to be below the threshold
(its whole interval below it) sets the correlation the verdict grades. A
region below it as a point estimate only does not, but it stops the
verdict from reading “agreement thresholds met”: at best the verdict is
“met, not confirmed”.

Both ICCs are reported deliberately. **ICC(3,1)** measures consistency
after allowing for systematic differences in measurement means; it is
not a rank correlation. **ICC(2,1)** measures absolute agreement and
also penalizes systematic mean differences. Their comparison can help
identify offsets, but similar estimates (here 0.658 and 0.663) do not
establish that clinically important bias is absent. Read the paired
differences, their intervals and the limits of agreement before judging
interchangeability. The model treats measurements as crossed across
cases; an ICC from this cohort does not establish performance in a
different case mix.

Note that the mean inter-regional correlation (0.554) is well below the
region-reference correlation (0.760). Two cores agree with each other
*less* than either agrees with the whole section, which is what you
would expect when each core samples a different part of a heterogeneous
tumor.

The within-case CV pools, for each case, the reference and every region,
and combines the cases as a root mean square. Unlike a plain average of
the per-case CVs, it does not fall when a case has fewer measurements.

### Sampling Bias

                           comparison  n mean_diff ci_lower ci_upper loa_lower loa_upper p_value
                 Biopsy1 vs reference 40     0.287   -2.154    2.729   -14.675    15.250   0.813
                 Biopsy2 vs reference 40     0.110   -3.316    3.536   -20.886    21.106   0.949
                 Biopsy3 vs reference 40     1.400   -3.355    6.155   -27.741    30.541   0.555
     Mean of all regions vs reference 40     0.599   -1.395    2.594   -11.625    12.823   0.547

                           comparison                                              clinical_impact
                 Biopsy1 vs reference  +0.7% (90% CI -4.5% to 6.0%): inconclusive at the 5% margin
                 Biopsy2 vs reference  +0.3% (90% CI -7.0% to 7.6%): inconclusive at the 5% margin
                 Biopsy3 vs reference +3.6% (90% CI -6.6% to 13.7%): inconclusive at the 5% margin
     Mean of all regions vs reference  +1.5% (90% CI -2.7% to 5.8%): inconclusive at the 5% margin

`clinical_impact` is the column to read, not `p_value`. Each difference
is judged against `bias_margin`, here 5% of the reference mean. It is
ruled out when its 90% CI lies inside the margin (two one-sided tests),
shown to be material when a Bonferroni-adjusted CI lies entirely beyond
it, and inconclusive otherwise. All four rows are inconclusive. The
estimates are small (0.3% to 3.6%), but with 40 cases the 90% CIs still
reach past 5% (Biopsy3 up to 13.7%), so a non-significant p-value here
does not show that the regions are unbiased.

The limits of agreement say how far a single case can differ: for
Biopsy3 between -27.7 and +30.5 points. The table also gives the 95% CI
of each limit (Bland & Altman 1999; for Biopsy3, -35.9 to -19.5 and 22.3
to 38.7), which is wide with 40 cases.

### Variance Components

                           component variance percentage                   contribution
               Between-Case Variance   196.65       65.8              Major contributor
     Within-Case Variance (Sampling)   102.19       34.2  Large share of total variance
                     Method Variance     0.00        0.0  Small share of total variance
                      Total Variance   298.84      100.0 Sum of all variance components

**34.2% of the total variance is within-case** in this fitted model.
This component includes regional differences and residual measurement
variation; it cannot be attributed entirely to where the tumor was
sampled. A threshold applied to a single core can be affected by either.
Report the variance model and its assumptions alongside this descriptive
percentage. The share labels are descriptive. Every share depends on how
much the cases differ from one another, so judge how much the
measurements disagree from the within-case CV.

### Sample Size for ICC Precision

                                                     scenario planning_icc width_current n_w20 n_w10
          Planning ICC 0.75 (lower limit of good reliability)        0.750         0.210    44   171
     Planning ICC 0.90 (lower limit of excellent reliability)        0.900         0.099    13    40
                               Observed ICC(3,1), consistency        0.658         0.258    67   266

This is the planning question an agreement study has: how many cases pin
the ICC down. With four measurements per case (the reference and three
regions), 44 cases give an expected 95% CI width of 0.20 if the true ICC
is 0.75. At the ICC observed here (0.66) the same precision needs 67
cases, and a width of 0.10 needs 266. The widths are expected values:
Bonett’s (2002) approximation, refined by averaging the exact F-interval
width. Some studies of that size will obtain a wider interval, so this
is not an assurance calculation.

### The Verdict

The Clinical Assessment reads **Inadequate sampling**. The mean
correlation meets 0.7, but the within-case CV (30.9%) is above the 20%
threshold. It is also above the relaxed band of 30% (1.5 times the
threshold) that would have given “Moderate sampling”, a heuristic of
this analysis rather than a published criterion. The assessment suggests
averaging more than one region per case. Even with the CV threshold met,
the verdict could not have read “agreement thresholds met”: Biopsy3’s
correlation is below 0.7 as a point estimate, and no systematic
difference has been ruled out.

## Spatial Compartments

When regions are labeled by anatomical compartment, say invasive front
versus tumor center, `spatial_id` names that column and the two
compartment options compare them:

\
`res_spatial`` ``<-`` `[`ihcheterogeneity`](https://www.serdarbalci.com/OncoPath/reference/ihcheterogeneity.md)`(`\
`  data                ``=`` ``ihc``,`\
`  wholesection        ``=`` ``"Whole"``,`\
`  biopsy1             ``=`` ``"Biopsy1"``,`\
`  biopsy2             ``=`` ``"Biopsy2"``,`\
`  spatial_id          ``=`` ``"Compartment"``,`\
`  compareCompartments ``=`` ``TRUE``,`\
`  compartmentTests    ``=`` ``TRUE`\
`)`

                                       test_type statistic df1 df2 p_value
               Kruskal-Wallis test (per-case CV)     0.354   1  NA   0.552
     Brown-Forsythe test (spread of per-case CV)     0.125   1  38   0.725
            Kruskal-Wallis test (per-case means)     0.089   1  NA   0.766

The compartments in this example were assigned by row, not by biology.
These particular tests are non-significant; random assignment does not
guarantee a non-significant result. The Kruskal-Wallis test on per-case
CV compares the distributions of CVs; the other two compare their spread
and the distribution of per-case biomarker means. Interpreting
Kruskal-Wallis as a test of medians additionally requires similarly
shaped distributions.

`spatial_id` assigns one compartment to each case (row), so these are
comparisons of independent case groups. They do not estimate a paired
center-versus-front effect within the same tumors. Different case mix,
marker levels and measurement precision can explain a difference. Do not
duplicate cases into rows and interpret these independent-group tests as
paired spatial evidence.

## Reading the Result

- `analysis_type` sets how much is shown: `reproducibility` for the
  correlations, ICCs, CV and systematic differences; `variability` adds
  the variance components and the plots; `comprehensive` (the default)
  adds sample-size planning as well.
- `bias_margin` (default 5, percent of the comparison mean) is the
  largest systematic difference you would accept. Choose it, like the
  two thresholds below, before looking at the results.
- `cv_threshold` (default 20) and `correlation_threshold` (default 0.8)
  set the bars against which results are labeled acceptable. They are
  conventions, not standards. If your assay has a published
  reproducibility requirement, use that number instead.
- `sampling_strategy` documents how the regions were chosen. It does not
  change the arithmetic, but it belongs in the record: results from
  systematically placed cores do not generalize to randomly placed ones.
- `showSummary` adds a plain-language summary and `showGlossary` a
  statistics glossary, both useful when the output is going to a tumor
  board rather than a statistician.
- Scores that take only a few whole-number values (HER2 0 to 3+, an
  Allred score, or a percentage recorded in coarse steps) are not
  graded: the CV and the percentage margin assume a finely measured
  continuous scale. Assess an ordinal score with weighted kappa instead.

## Limitations

The analysis describes the cases you measured. It cannot tell you that
two cores are sufficient in general, only that, in this cohort, 34% of
the variance lay within cases rather than between them. Extending that
to a clinical protocol needs a prospectively defined validation study,
with the threshold and the decision it drives specified in advance. A
small average offset or a high correlation does not establish agreement
at an individual patient’s clinical cutoff. Examine classification
changes near that cutoff in a separate validation. Ordinal-score
detection is a data-based heuristic; confirm the scale yourself,
especially for rounded percentages.

The ICC forms and their interpretation follow [Koo and Li
(2016)](https://pmc.ncbi.nlm.nih.gov/articles/PMC4913118/).
