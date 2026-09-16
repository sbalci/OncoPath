# Hand-maintained: @importFrom tags to satisfy R CMD check's
# 'Namespaces in Imports field not imported from' NOTE.
#
# Every package below IS used, via pkg:: inside R6 method bodies (.run/.plot in
# the .b.R classes). R CMD check scans the INSTALLED namespace and only walks
# objects that are functions; an R6ClassGenerator is not one, so the pkg:: calls
# in its methods are invisible to it and the packages look unused. Do NOT move
# them to Suggests or prune them from Imports -- jamovi installs Imports on first
# run and cannot fetch a missing package on demand.
#
# magrittr is here for a different reason: `%>%` is a BARE SYMBOL, so it resolves
# only from this package's own namespace or its imports -- listing magrittr in
# DESCRIPTION Imports puts nothing in scope. The 2026-09-16 OncoPath audit found
# the tag missing with 114 uses live in waterfall.b.R and swimmerplot.b.R, so
# `waterfall` failed with `could not find function "%>%"` on its default options
# and produced no output. devtools::load_all() and this machine's ~/.Rprofile
# (which attaches magrittr) both hide it; jamovi's engine reads neither. Verify
# with Rscript --vanilla.
#' @importFrom ggrepel geom_text_repel
#' @importFrom grDevices colorRampPalette
#' @importFrom grid viewport
#' @importFrom magrittr %>%
#' @importFrom patchwork wrap_plots
#' @importFrom psych ICC
#' @importFrom rlang sym
#' @importFrom stringr str_to_title
#' @importFrom survival survfit
#' @importFrom utils packageName
NULL
