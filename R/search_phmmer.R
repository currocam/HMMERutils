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
#' @param N.TRIES An integer specifying the number of attempts before
#'  an error occurs.
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
    N.TRIES = 1,
    verbose = TRUE) {
    # Check
    seqs <- deal_with_input_sequences(seqs)
    if (length(seqs) == length(seq_names)) {
      names(seqs) <- make.unique(seq_names)
    }
    # all combinations of inputs
    grid <- tidyr::expand_grid(seqs, dbs) %>%
      dplyr::mutate("seq.name" = names(.data$seqs))
    tbl_list <- purrr::map2(
        .x = grid$seqs,
        .y = grid$dbs,
        .f = ~ {
            request_hmmer(
                seq = .x,
                seqdb = .y,
                url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
                verbose = verbose,
                N.TRIES = N.TRIES
            )
        }
    ) %>%
        parse_xml_into_tbl()
    names_seq <- NULL
    if (!is.null(seq_names)) {
      names_seq <- grid$seq.name
    }
    create_hmmer_AnnotatedDataFrame(grid, names_seq, tbl_list, type = "phmmer")
}

