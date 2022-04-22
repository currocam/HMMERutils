#' Perform an iterative search of a protein sequence or an alignment against
#'  a protein sequence database.
#'
#' @param seqs A character vector containing the sequences of the query or
#'  any other object that can be converted to that.
#' @param alns A Biostrings::AAMultipleAlignment or a list of
#'   Biostrings::AAMultipleAlignment.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param N.TRIES An integer specifying the number of attempts before
#'  an error occurs.
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a nested DataFrame
#'  with the search hashes, the download links of all available files and
#'   of the HMMER page where the results are hosted, and the metadata
#'   associated to this DataFrame. Although all available results are available
#'    here, we recommend using the `extract_from_HMMER_data_tbl` function
#'     to preprocess the data.
#'
#' @examples
#' jackhmmer_tbl_using_seq <- search_jackhmmer(
#'    seqs = "MTEITAAMVKELRTGAGMMDCKN",
#'   seq_or_aln_names = "1efu_B",
#'   dbs = "pdb",
#'   verbose = FALSE)
#' jackhmmer_tbl_using_seq
#' Biobase::varMetadata(jackhmmer_tbl_using_seq)
#'
#' path_to_example_aln <- system.file(
#'   "extdata/alignment_example.afa",
#'   package = "HMMERutils")
#' alns <- Biostrings::readAAMultipleAlignment(path_to_example_aln)
#'jackhmmer_tbl_using_aln <- search_jackhmmer(
#'   alns = alns,
#'   dbs = "pdb",
#'   verbose = TRUE)
#' jackhmmer_tbl_using_aln
#' Biobase::varMetadata(jackhmmer_tbl_using_aln)
#' @export

search_jackhmmer <- function(
    seqs = NULL,
    alns = NULL,
    seq_or_aln_names = NULL,
    dbs = "swissprot",
    fullseqfasta = TRUE,
    verbose = TRUE,
    N.TRIES = 1) {
    if (all(!is.null(seqs), !is.null(alns))) {
        stop(
            "You cannot use both an alignment and a sequence for the search.\n",
            "Use one and then the other. "
        )
    }
    if (!is.null(seqs)) {
        seqs <- deal_with_input_sequences(seqs)
        if (length(seqs) == length(seq_or_aln_names)) {
          names(seqs) <- make.unique(seq_or_aln_names)
        }
        grid <- tidyr::expand_grid(seqs, dbs) %>%
          dplyr::mutate("seq.name" = names(.data$seqs))
    }
    if (!is.null(alns)) {
        alns <- deal_with_input_aln(alns)
        if (length(alns) == length(seq_or_aln_names)) {
          names(alns) <- make.unique(seq_or_aln_names)
        }
        grid <- tidyr::expand_grid(alns, dbs) %>%
          dplyr::mutate("seq.name" = names(.data$alns))
    }
    if (!is.null(seqs)) {
        tbl_list <- purrr::map2(
            .x = grid$seqs, .y = grid$dbs,.f = ~ {
                request_hmmer(
                    seq = .x,seqdb = .y,
                    url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
                    verbose = TRUE, N.TRIES = N.TRIES)})
    }
    if (!is.null(alns)) {
        tbl_list <- purrr::map2(
            .x = grid$alns,.y = grid$dbs,.f = ~ {
                request_hmmer(
                    aln = .x,seqdb = .y,
                    url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
                    verbose = TRUE,N.TRIES = N.TRIES)})
    }
    tbl_list <- tbl_list %>%
        parse_xml_into_tbl()
    names_seq <- NULL
    if (!is.null(seq_or_aln_names)) {
      names_seq <- grid$seq.name
    }
    create_hmmer_AnnotatedDataFrame(grid, names_seq, tbl_list,type = "jackhmmer")
}
