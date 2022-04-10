#' Perform an iterative search of a protein sequence or an alignment against
#'  a protein sequence database.
#'
#' @param seqs A vector of characters containing the sequences of the query.
#' @param alns A list of Biostrings::AAMultipleAlignment.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param fullseqfasta  A logical, if TRUE full sequence fasta will be downloaded
#'  as a AAStringSet. Package `Biostrings` must be installed in that case.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout An integer specifying the number of seconds to wait for the
#'  reply before a time out occurs.
#' @param alignment A logical, if TRUE sequence alignment will be downloaded
#'  as a `AAMultipleAlignment`. Package `Biostrings` must be installed in that case.
#' @return A nested DataFrame with columns `seqs`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and, if selected,
#'   `fullseq.fasta.` and `alignment`.
#' @seealso \code{\link{ABL1_homologous}} for a detailed description of the meaning
#'  of the different variables.
#' @examples
#' try(
#'     jackhmmer_tbl <- search_jackhmmer(
#'         seqs = "MTEITAAMVKELRTGAGMMDCKN",
#'         dbs = "pdb",
#'         verbose = FALSE,
#'         timeout = 15
#'     )
#' )
#' @export

search_jackhmmer <- function(seqs = NULL,
    alns = NULL,
    dbs = "swissprot",
    fullseqfasta = TRUE,
    verbose = TRUE,
    timeout = 90,
    alignment = FALSE) {
    if (all(!is.null(seqs), !is.null(alns))) {
        stop(
            "You cannot use both an alignment and a sequence for the search.\n",
            "Use one and then the other. "
        )
    }
    if (!is.null(seqs)) {
        seqs <- deal_with_input_sequences(seqs)
    }
    if (!is.null(alns)) {
        alns <- deal_with_input_aln(alns)
    }
    # all combinations of inputs
    grid <- tidyr::expand_grid(seqs, alns, dbs)

    if (!is.null(seqs)) {
        tbl_list <- purrr::map2(
            .x = grid$seqs,
            .y = grid$dbs,
            .f = ~ {
                request_hmmer(
                    seq = .x,
                    seqdb = .y,
                    url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
                    verbose = TRUE
                )
            }
        )
    }
    if (!is.null(alns)) {
        tbl_list <- purrr::map2(
            .x = grid$alns,
            .y = grid$dbs,
            .f = ~ {
                request_hmmer(
                    aln = .x,
                    seqdb = .y,
                    url = "https://www.ebi.ac.uk/Tools/hmmer/search/jackhmmer",
                    verbose = TRUE
                )
            }
        )
    }
    tbl_list <- tbl_list %>%
        parse_xml_into_tbl()

    df <- grid %>%
        dplyr::mutate(
            "seq.name" = names(seqs),
            "uuid" = purrr::flatten_chr(tbl_list$uuid),
            "url" = purrr::flatten_chr(tbl_list$url),
            "stats" = tbl_list$stats,
            "hits" = tbl_list$hits,
            "domains" = tbl_list$domains
        )
    if (fullseqfasta) {
        df <- mutate_fullseqfasta(df, df$uuid)
    }
    if (alignment) {
        df <- mutate_alignment(df, df$uuid)
    }
    class(df) <- c("HMMER_data_tbl", class(df))
    return(df)
}
