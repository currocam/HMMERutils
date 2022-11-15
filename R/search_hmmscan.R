#' Perform a hmmscan search of a protein sequence
#'  against a profile-HMM database.
#'
#' @param seq A character vector containing the sequences of the query or
#'  any other object that can be converted to that. It can also be a URL or
#'  the path to a FASTA file.
#' @param hmmdb A character vector containing the target databases. Frequently
#'  used databases are `pfam`, `tigrfam` `gene3d`, `superfamily`, `pirsf` and
#'   `treefam`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout Set maximum request time in seconds.
#'
#' @return An Data Frame containing the results from HMMER.
#'
#' @examples
#' search_hmmscan(
#'     seq = "SWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSS",
#'     hmmdb = "pfam",
#'     verbose = FALSE
#' )
#' @export

search_hmmscan <- function(seq, hmmdb = "pfam",
    timeout = 180, verbose = FALSE) {
    httr::reset_config()
    if (verbose) {
        httr::set_config(httr::verbose())
    }
    seq <- convert_input_seq(seq)
    hmmscan <- purrr::possibly(search_in_hmmer, otherwise = NULL)
    # all combinations of inputs
    tidyr::expand_grid(seq, hmmdb, algorithm = "hmmscan") %>%
        dplyr::rowwise() %>%
        purrr::pmap(
            ~ hmmscan(
                seq = ..1,
                hmmdb = ..2,
                algorithm = ..3,
                timeout_in_seconds = timeout
            )
        ) %>%
        purrr::compact() %>%
        dplyr::bind_rows()
}
