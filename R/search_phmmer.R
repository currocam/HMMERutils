#' Perform a phmmer search of a protein sequence against a protein sequence database.
#'
#' @param seqs A character vector containing the sequences of the query or
#'  any other object that can be converted to that.
#' @param seq_names A character vector containing the names of the sequences
#'  of the query. By default `seq_names = NULL`.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout Set maximum request time in seconds.
#'
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a nested DataFrame
#'  with the search hashes, the download links of all available files and
#'   of the HMMER page where the results are hosted, and the metadata
#'   associated to this DataFrame. Although all available results are available
#'    here, we recommend using the `extract_from_HMMER_data_tbl` function
#'    to preprocess the data.
#'
#' @examples
#' phmmer_tbl <- search_phmmer(
#'   seqs = "MTEITAAMVKELRTGAGMMDCKN",
#'   seq_names = "1efu_B",
#'   dbs = "pdb",
#'   verbose = FALSE)
#' phmmer_tbl
#' Biobase::varMetadata(phmmer_tbl)
#' @export

search_phmmer <- function(
    seqs,
    seq_names = NULL,
    dbs = "swissprot",
    timeout = 180,
    verbose = FALSE) {
    seqs <- sequences_to_phmmer(seqs, seq_names)
    # all combinations of inputs
    httr::reset_config()
    if (verbose) {
      httr::set_config(httr::verbose())
    }
    tbl_list <- tidyr::expand_grid(seqs, dbs) %>%
      dplyr::mutate("seq.name" = names(.data$seqs))%>%
      dplyr::mutate(HMMER_response =purrr::map2(
        seqs, dbs, ~search_in_HMMER_safely(
          algorithm = "phmmer",
          sequence = .x,
          database = .y,
          timeout_in_seconds = timeout)))%>%
      dplyr::mutate("is_parsed_HMMER_response" = HMMER_response %>%
                      purrr::map_lgl(~is(., "parsed_HMMER_response")))%>%
      dplyr::filter(.data$is_parsed_HMMER_response)%>%
      dplyr::select(-is_parsed_HMMER_response)

    create_hmmer_AnnotatedDataFrame(tbl_list, algorithm = "phmmer")
}


sequences_to_phmmer <- function(seqs, seq_names){
  seqs <- deal_with_input_sequences(seqs)
  if (length(seqs) == length(seq_names)) {
    names(seqs) <- make.unique(seq_names)
  }
  if (is.null(names(seqs))) {
    names(seqs) <- seq(1, length(seqs))
  }
  return(seqs)
}

search_in_HMMER_safely <- purrr::possibly(
  otherwise = list(NULL),
  function(algorithm, sequence, database, timeout_in_seconds){
    construct_query_object(
      algorithm,input = sequence,db = database,
      timeout_in_seconds = timeout_in_seconds
      ) %>%
      post_HMMER_api_search()%>%
      parse_response_into_tbl()
  })
