#' Diagnostic Studies Sample Dataset
#'
#' Five synthetic diagnostic accuracy studies (2x2 tables) for the
#' \code{diagnosticmeta} analysis. Five studies are too few for heterogeneity
#' or meta-regression; use \code{diagnosticmeta_test_categorical} for those.
#'
#' @format A data frame with 5 rows and 5 variables:
#' \describe{
#'   \item{study_name}{Study identifier}
#'   \item{tp}{Number of true positive results}
#'   \item{fp}{Number of false positive results}
#'   \item{fn}{Number of false negative results}
#'   \item{tn}{Number of true negative results}
#' }
#' @source Synthetic data generated for the ClinicoPath project.
"diagnostic_studies"

#' Histopathology Sample Dataset
#'
#' A general-purpose synthetic clinicopathological data frame (250 cases,
#' 38 variables) from the ClinicoPath project. No OncoPath analysis uses it;
#' it is included as a frame for exploring jamovi. The \code{Name} column holds
#' invented first names, several logical columns are coded with Turkish
#' TRUE/FALSE strings, and the column "Golden Standart" keeps its original
#' spelling.
#'
#' @format A data frame with 250 rows and 38 variables.
#' @source Simulated example data from the ClinicoPath project.
"histopathology"

#' Swimmer Plot Sample Dataset
#'
#' Twenty synthetic patients for the \code{swimmerplot} analysis. Times are in
#' months from the start of treatment. The data have no censoring status column.
#'
#' @format A data frame with 20 rows and 10 variables:
#' \describe{
#'   \item{PatientID}{Patient identifier, PT001 to PT020}
#'   \item{StartTime}{Start of follow-up (months; 0 for every patient)}
#'   \item{EndTime}{End of follow-up (months, 11 to 28)}
#'   \item{Response}{Best response: CR, PR, SD or PD}
#'   \item{Surgery}{Time of surgery (months)}
#'   \item{TreatmentStart}{Time treatment started (months)}
#'   \item{ResponseAssessment}{Time of the response assessment (months)}
#'   \item{Progression}{Time of progression (months); NA if none}
#'   \item{EventType}{Name of a clinical event ("Treatment Start")}
#'   \item{EventTime}{Time of that event (months)}
#' }
#' @source Synthetic data generated for the ClinicoPath project.
"swimmerplot_sample"

#' Waterfall Plot Percentage Basic Dataset
#'
#' Twenty synthetic patients for the \code{waterfall} analysis with
#' percentage input: one row per patient.
#'
#' @format A data frame with 20 rows and 3 variables:
#' \describe{
#'   \item{PatientID}{Patient identifier, PT01 to PT20}
#'   \item{Response}{Best percent change in tumour burden from baseline
#'     (negative = shrinkage; -100 = complete disappearance)}
#'   \item{Treatment}{Treatment arm: Drug A or Drug B (10 patients each)}
#' }
#' @source Synthetic data generated for the ClinicoPath project.
"waterfall_percentage_basic"

#' Waterfall Plot Raw Longitudinal Dataset
#'
#' Fifteen synthetic patients for the \code{waterfall} analysis with raw
#' input and the spider plot: one row per patient per visit. The values are
#' the same as in the jamovi example \code{waterfall_raw_longitudinal.omv}.
#'
#' @format A data frame with 60 rows and 3 variables:
#' \describe{
#'   \item{PatientID}{Patient identifier, PT01 to PT15}
#'   \item{Time}{Visit time in months (0 = baseline, then 2, 4 and 6)}
#'   \item{Measurement}{Tumour burden at that visit, in mm (for example a sum
#'     of diameters), 0 to 90}
#' }
#' @source Synthetic data generated for the ClinicoPath project
#'   (\code{data-raw/waterfall_comprehensive_test_data.R}).
"waterfall_raw_longitudinal"
