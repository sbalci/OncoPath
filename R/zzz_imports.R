# Hand-maintained: @importFrom tags to satisfy R CMD check's
# 'Namespaces in Imports field not imported from' NOTE.
#
# Every package below IS used, via pkg:: inside R6 method bodies (.run/.plot in
# the .b.R classes). R CMD check scans the INSTALLED namespace and only walks
# objects that are functions; an R6ClassGenerator is not one, so the pkg:: calls
# in its methods are invisible to it and the packages look unused. Do NOT move
# them to Suggests or prune them from Imports -- jamovi installs Imports on first
# run and cannot fetch a missing package on demand.
#' @importFrom ggrepel geom_text_repel
#' @importFrom grDevices colorRampPalette
#' @importFrom grid viewport
#' @importFrom patchwork wrap_plots
#' @importFrom psych ICC
#' @importFrom rlang sym
#' @importFrom stringr str_to_title
#' @importFrom survival survfit
#' @importFrom utils packageName
NULL
