#' Add sequences from one of the output files from HMMER
#'   server to a Data Frame obtained by searching in HMMER.
#'
#' @param data A Data Frame obtained with HMMERutils.
#' @param extension A one-element character vector with
#'  either "fullfasta" or "fasta".
#' @param max_times An integer with the maximum number of
#'   trials before throwing an error.
#'
#' @return A DataFrame with a new column named "hits.fullfasta" or
#'   "hits.fasta" with the sequences.
#' 
#' @examples
#' githubURL <- "https://raw.githubusercontent.com/currocam/HMMERutils/4-extract_from_hmmer/inst/extdata/data_short.rds"
#' download.file(githubURL,"short_data.rds",method="curl")
#' data <- readRDS("short_data.rds")
#' add_sequences_to_hmmer_tbl(
#'     data = data,
#'     extension = "fullfasta",
#'     max_times = 3
#' )
#' @export
#'
add_sequences_to_hmmer_tbl <- function(data, extension = "fullfasta",
    max_times = 3) {
    stopifnot(any("uuid" %in% colnames(data)))
    stopifnot(any("hits.name" %in% colnames(data)))
    inner_function <- purrr::insistently(
        rate = purrr::rate_backoff(max_times = max_times, ),
        f = function(x) {
            x$uuid %>%
                unique() %>%
                create_download_url_for_hmmer(extension) %>%
                download_file() %>%
                Biostrings::readAAStringSet() %>%
                add_AAStringSet_to_tbl(data, extension)
        }
    )
    group_var <- rlang::sym("uuid")
    data %>%
        dplyr::group_by(!!group_var) %>%
        dplyr::group_split() %>%
        purrr::map_dfr(~ purrr::possibly(inner_function, .)(.))
}


add_AAStringSet_to_tbl <- function(fasta, data, extension) {
    col_name <- paste0("hits.", extension)
    x <- tibble::tibble("hits.name" = names(fasta))
    x[c(col_name)] <- as.character(fasta)
    data %>%
        dplyr::full_join(x, by = c("hits.name" = "hits.name"))
}
