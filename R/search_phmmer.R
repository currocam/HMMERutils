#' Perform a phmmer search of a protein sequence
#'  against a protein sequence database.
#'
#' @param seq A character vector containing the sequences of the query or
#'  any other object that can be converted to that. It can also be a URL or
#'   the path to a FASTA file.
#' @param seqdb A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, 
#' `ensembl`,
#' `pdb` and `alphafold`, but a complete and updated list is available at
#' \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout Set maximum request time in seconds.
#'
#' @return An Data Frame containing the results from HMMER.
#'
#' @examples
#' search_phmmer(
#'     seq = "MTEITAAMVKELRTGAGMMDCKN",
#'     seqdb = "pdb",
#'     verbose = FALSE
#' )
#' @export

search_phmmer <- function(seq, seqdb = "swissprot",
    timeout = 180, verbose = FALSE) {
    httr::reset_config()
    if (verbose) {
        httr::set_config(httr::verbose())
    }
    phmmer <- purrr::possibly(search_in_hmmer, otherwise = NULL)
    seq <- convert_input_seq(seq)
    # all combinations of inputs
    tidyr::expand_grid(seq, seqdb, algorithm = "phmmer") %>%
        dplyr::rowwise() %>%
        purrr::pmap(
            ~ phmmer(
                seq = ..1,
                seqdb = ..2,
                algorithm = ..3,
                timeout_in_seconds = timeout
            )
        ) %>%
        purrr::compact() %>%
        dplyr::bind_rows()
}
