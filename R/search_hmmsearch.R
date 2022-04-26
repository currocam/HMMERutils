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
#' @param N.TRIES An integer specifying the number of trials before a time out occurs.
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
  N.TRIES = 1) {
    # Check
  alns <- deal_with_input_aln(alns)
  if (length(alns) == length(aln_names)) {
    names(alns) <- make.unique(aln_names)
  }
  grid <- tidyr::expand_grid(alns, dbs) %>%
    dplyr::mutate("seq.name" = names(.data$alns))
  tbl_list <- purrr::map2(
      .x = grid$alns,
      .y = grid$dbs,
      .f = ~ {
          request_hmmer(
              aln = .x,
              seqdb = .y,
              url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmsearch",
              verbose = verbose,
              N.TRIES = N.TRIES
          )
      }
  ) %>%
      parse_xml_into_tbl()
  names_seq <- NULL
  if (!is.null(aln_names)) {
    names_seq <- grid$seq.name
  }
  create_hmmer_AnnotatedDataFrame(grid, names_seq, tbl_list,type = "hmmsearch")
}
