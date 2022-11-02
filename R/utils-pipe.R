#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' 
#' @examples
#' githubURL <- "https://raw.githubusercontent.com/currocam/HMMERutils/4-extract_from_hmmer/inst/extdata/data_short.rds"
#' download.file(githubURL,"short_data.rds",method="curl")
#' data <- readRDS("short_data.rds")
#' data %>% dplyr::select(tidyselect::starts_with("pdbs"))
#' @return The result of calling `rhs(lhs)`.
NULL
