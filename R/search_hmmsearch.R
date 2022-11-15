#' Perform a hmmsearch search of a protein sequence
#'  against a protein sequence database.
#'
#' @param aln A Biostrings::AAMultipleAlignment or a list of
#'   Biostrings::AAMultipleAlignment.
#' @param seqdb A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout Set maximum request time in seconds.
#'
#' @return An Data Frame containing the results from HMMER.
#'
#' @examples
#' system.file("extdata", "alignment.fasta", package = "HMMERutils") %>%
#'     Biostrings::readAAMultipleAlignment() %>%
#'     search_hmmsearch(
#'         seqdb = "swissprot",
#'         timeout = 180,
#'         verbose = FALSE
#'     )
#' @export
#' @importFrom rlang .data

search_hmmsearch <- function(aln, seqdb = "swissprot",
    timeout = 180, verbose = FALSE) {
    httr::reset_config()
    if (verbose) {
        httr::set_config(httr::verbose())
    }
    hmmsearch <- purrr::possibly(search_in_hmmer, otherwise = NULL)
    # all combinations of inputs
    seq <- ifelse(is.list(aln), aln, list(aln)) %>%
        purrr::map_chr(function(x) {
            Biostrings::unmasked(x) %>%
                format_AAStringSet_into_hmmer_string()
        })
    tidyr::expand_grid(seq, seqdb, algorithm = "hmmsearch") %>%
        dplyr::rowwise() %>%
        purrr::pmap(
            ~ hmmsearch(
                seq = ..1,
                seqdb = ..2,
                algorithm = ..3,
                timeout_in_seconds = timeout
            )
        ) %>%
        purrr::compact() %>%
        dplyr::bind_rows()
}
