#' Perform a hmmsearch search of a protein alignment against a protein sequence database.
#'
#' @param alns A Biostrings::AAMultipleAlignment or a list of
#'   Biostrings::AAMultipleAlignment.
#' @param aln_names A character vector containing the names of the aligments.
#' If `alns` is a named list it will overwrite them. If not specified, they
#' will not be taken into account.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout Set maximum request time in seconds.
#'
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a nested DataFrame
#'  with the search hashes, the download links of all available files and
#'  of the HMMER page where the results are hosted, and the metadata
#'  associated to this DataFrame. Although all available results are available
#'  here, we recommend using the `extract_from_HMMER_data_tbl` function
#'  to preprocess the data.
#'
#' @examples
#' path_to_example_aln <- system.file(
#'   "extdata/alignment_example.afa",
#'   package = "HMMERutils")
#' alns <- Biostrings::readAAMultipleAlignment(path_to_example_aln)
#'hmmsearch_tbl <- search_hmmsearch(
#'   alns = alns,
#'   dbs = "pdb",
#'   verbose = FALSE)
#' hmmsearch_tbl
#' Biobase::varMetadata(hmmsearch_tbl)
#' @export

search_hmmsearch <- function(
  alns,
  aln_names = NULL,
  dbs = "swissprot",
  verbose = TRUE,
  timeout = 180) {
  alns <- sequences_to_hmmsearch(alns, aln_names)
  httr::reset_config()
  if (verbose) {
    httr::set_config(httr::verbose())
  }
  tbl_list <- tidyr::expand_grid(alns, dbs) %>%
    dplyr::mutate("seq.name" = names(.data$alns))%>%
    dplyr::mutate(HMMER_response =purrr::map2(
      alns, dbs, ~search_in_HMMER_safely(
        algorithm = "hmmsearch",
        sequence = .x,
        database = .y,
        timeout_in_seconds = timeout)))%>%
    dplyr::mutate("is_parsed_HMMER_response" = HMMER_response %>%
                    purrr::map_lgl(~is(., "parsed_HMMER_response")))%>%
    dplyr::filter(is_parsed_HMMER_response)%>%
    dplyr::select(-is_parsed_HMMER_response)
  create_hmmer_AnnotatedDataFrame(tbl_list, algorithm = "hmmsearch")
}


sequences_to_hmmsearch <- function(alns, aln_names){
  alns <- deal_with_input_aln(alns)
  if (length(alns) == length(aln_names)) {
    names(alns) <- make.unique(aln_names)
  }
  if (is.null(names(alns))) {
    names(alns) <- seq(1, length(alns))
  }
  return(alns)
}
