#' Read the results of a search with HMMER from an json file.
#'
#' @param file A a character vector the containing filepaths to
#'   XML file downloaded from HMMER.
#'
#' @return A Data Frame with the results
#'
#' @examples
#' read_hmmer_from_json(
#'     file = "inst/extdata/phmmer_2abl.xml"
#' )
#' @export
#'
read_hmmer_from_json <- function(file) { # nolint
    if (is.null(names(file))) {
        names(file) <- file
    }
    inner_function <- purrr::possibly(
        otherwise = NULL,
        .f = function(x) {
            jsonlite::read_json(x) %>%
                purrr::pluck("results") %>%
                parse_results_into_tbl()
        }
    )
    purrr::map_dfr(.x = file, .id = "file", .f = inner_function)
}
