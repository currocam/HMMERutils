#' hmmscan search of a protein sequence against a profile-HMM database.
#' @param seqs A character vector containing the sequences of the query or
#'  any other object that can be converted to that.
#' @param seq_names A character vector containing the names of the sequences.
#' If `seqs` is a named vector it will overwrite them. If not specified, they
#' will not be taken into account.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `pfam`, `tigrfam` `gene3d`, `superfamily`, `pirsf` and
#'   `treefam`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param N.TRIES An integer specifying the number of trials before a time out occurs.
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a nested DataFrame
#'  with the search hashes, the download links of all available files and
#'  of the HMMER page where the results are hosted, and the metadata
#'  associated to this DataFrame. Although all available results are available
#'  here, we recommend using the `extract_from_HMMER_data_tbl` function
#'  to preprocess the data.
#'
#'
#' @importFrom rlang .data
#' @export
#'
#' @examples
#'path_to_example_fasta <- system.file(
#'  "extdata/fasta_seq_example.fa",
#'  package = "HMMERutils")
#'seqs <- Biostrings::readAAStringSet(path_to_example_fasta)
#'hmmscan_tbl <- search_hmmscan(
#'  seqs = seqs,
#'  dbs = "pfam",
#'  verbose = FALSE)
#'hmmscan_tbl
#'Biobase::varMetadata(hmmscan_tbl)
#' @export

search_hmmscan <- function(
    seqs,
    seq_names = NULL,
    dbs = "pfam",
    verbose = TRUE,
    N.TRIES = 1) {
    seqs <- sequences_to_hmmscan(seqs, seq_names)
    # all combinations of inputs
    tbl_list <- tidyr::expand_grid(seqs, dbs) %>%
      dplyr::mutate("seq.name" = names(.data$seqs))%>%
      dplyr::mutate(HMMER_response =purrr::map2(
        seqs, dbs, ~search_in_HMMER_safely(
          algorithm = "hmmscan",
          sequence = .x,
          database = .y,
          timeout_in_seconds = 100)))%>%
      dplyr::mutate("is_parsed_HMMER_response" = HMMER_response %>%
                      purrr::map_lgl(~is(., "parsed_HMMER_response")))%>%
      dplyr::filter(is_parsed_HMMER_response)%>%
      dplyr::select(-is_parsed_HMMER_response)
    create_hmmer_AnnotatedDataFrame(tbl_list, algorithm = "hmmscan")
  }


sequences_to_hmmscan <- function(seqs, seq_names){
  seqs <- deal_with_input_sequences(seqs)
  if (length(seqs) == length(seq_names)) {
    names(seqs) <- make.unique(seq_names)
  }
  if (is.null(names(seqs))) {
    names(seqs) <- seq(1, length(seqs))
  }
  return(seqs)
}
