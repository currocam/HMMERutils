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
#' @param max_tries Cap the maximum number of attempts with max_tries.
#'
#' @return An Data Frame containing the results from HMMER.
#'
#' @examples
#' search_phmmer(
#'   seq = "MTEITAAMVKELRTGAGMMDCKN",
#'   seqdb = "pdb",
#'   verbose = FALSE
#' )
#' @export
search_phmmer <- function(seq, seqdb, max_tries = 5, verbose = TRUE) {
  requests <- purrr::map2(
    seq, seqdb,
    ~ hmmer_request(
      algo = "phmmer", seq = convert_input_seq(.x), seqdb = .y
    )
  )
  if (verbose) {
    requests <- purrr::map(requests, httr2::req_verbose)
  }

  responses <- multi_req_perform_custom(requests)

  purrr::pmap(
    list(responses, seq, seqdb),
    ~ {
      data <- ..1 |>
        httr2::resp_body_json(simplifyVector = TRUE) |>
        purrr::chuck("results", "hits") |>
        tibble::as_tibble()
      colnames(data) <- paste0("hits.", colnames(data))

      data |>
        dplyr::mutate(sequence_header = names(..2), database = ..3) |>
        add_fullfasta(uuid = resp_get_uuid(..1))
    }
  ) |>
    dplyr::bind_rows(.id = "temporary_url")
}
