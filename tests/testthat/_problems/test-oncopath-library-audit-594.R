# Extracted from test-oncopath-library-audit.R:594

# prequel ----------------------------------------------------------------------
find_oncopath_audit_root <- function() {
  candidates <- c(".", "..", "../..")
  for (candidate in candidates) {
    description <- file.path(candidate, "DESCRIPTION")
    if (!file.exists(description)) {
      next
    }
    package <- read.dcf(description, fields = "Package")[[1]]
    if (package %in% c("ClinicoPath", "OncoPath")) {
      return(normalizePath(candidate))
    }
  }
  NA_character_
}
oncopath_root <- find_oncopath_audit_root()
oncopath_file <- function(...) file.path(oncopath_root, ...)
read_oncopath <- function(...) {
  paste(readLines(oncopath_file(...), warn = FALSE), collapse = "\n")
}
skip_if_no_oncopath_source <- function() {
  skip_if(
    is.na(oncopath_root),
    "package source tree not available in the installed test context"
  )
}
audit_analyses <- c("diagnosticmeta", "ihcheterogeneity", "swimmerplot", "waterfall")
audit_absent <- function(root, names, files = "R/%s.b.R") {
  on_disk <- function(path) basename(path) %in% list.files(file.path(root, dirname(path)))
  Filter(function(name) !all(vapply(sprintf(files, name), on_disk, logical(1))), names)
}
audit_loaded <- function(analyses) Filter(function(a) exists(paste0(a, "Class")), analyses)
audit_skip_absent <- function(absent, root = NULL, note = NULL) {
  if (length(absent) == 0) return(invisible())
  absent <- paste(absent, collapse = ", ")
  if (!is.null(root) &&
      identical(unname(read.dcf(file.path(root, "DESCRIPTION"))[1, "Package"]), "ClinicoPath"))
    stop("the umbrella keeps every analysis, parked or not, yet lacks: ", absent, call. = FALSE)
  testthat::skip(paste(c(paste0("not in this module (parked or not shipped): ", absent), note), collapse = "; "))
}
audit_skip_unloaded <- function(wanted) {
  unloaded <- setdiff(wanted, audit_loaded(wanted))
  if (length(unloaded) == 0) return(invisible())
  root <- normalizePath(file.path(testthat::test_path(), "..", ".."), mustWork = FALSE)
  if (!file.exists(file.path(root, "DESCRIPTION"))) audit_skip_absent(unloaded)
  absent <- audit_absent(root, unloaded)
  not_loaded <- paste0("class not loaded (package not loaded in this run): ",
                       paste(setdiff(unloaded, absent), collapse = ", "))
  audit_skip_absent(absent, root, if (length(absent) < length(unloaded)) not_loaded)
  testthat::skip(not_loaded)
}

# test -------------------------------------------------------------------------
skip_if_no_oncopath_source()
package <- read.dcf(oncopath_file("DESCRIPTION"), fields = "Package")[[1]]
skip_if(package != "OncoPath", "the umbrella keeps its own NEWS.md")
version <- unname(read.dcf(oncopath_file("DESCRIPTION"), fields = "Version")[[1]])
headings <- grep("^#{1,2} ", readLines(oncopath_file("NEWS.md"), warn = FALSE), value = TRUE)
pattern <- paste0("(^|[^0-9.])", gsub(".", "\\.", version, fixed = TRUE), "([^0-9.]|$)")
expect_true(any(grepl(pattern, headings)),
              info = paste0("DESCRIPTION ", version, "; newest NEWS.md heading: ", headings[1]))
