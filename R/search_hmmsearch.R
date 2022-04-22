#' Perform a hmmsearch search of a protein alignment against a protein sequence database.
#'
#' @param alns A list of Biostrings::AAMultipleAlignment.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `swissprot`, `uniprotrefprot`, `uniprotkb`, `ensembl`,
#'  `pdb` and `alphafold`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param fullseqfasta  A logical, if TRUE full sequence fasta will be downloaded
#'  as a AAStringSet. Package `Biostrings` must be installed in that case.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param N.TRIES An integer specifying the number of trials before a time out occurs.
#' @param alignment A logical, if TRUE sequence alignment will be downloaded
#'  as a `AAMultipleAlignment`. Package `Biostrings` must be installed in that case.#'
#'
#' @return A nested DataFrame with columns `alns`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and, if selected,
#'   `fullseq.fasta.` and `alignment`.
#'
#' @seealso \code{\link{ABL1_homologous}} for a detailed description of the meaning
#'  of the different variables.
#'
#' @examples
#' aln <- c(
#'     "MTEITAAMVKELR--TGAGMMDCKN",
#'     "------AMVKELRESTGAGMMDCKN"
#' ) %>%
#'     Biostrings::AAMultipleAlignment()
#' try(
#'     hmmsearch_tbl <- search_hmmsearch(
#'         alns = aln,
#'         dbs = "pdb",
#'         verbose = FALSE,
#'         timeout = 5
#'     )
#' )
#' @export

search_hmmsearch <- function(alns,
    dbs = "swissprot",
    fullseqfasta = TRUE,
    verbose = TRUE,
    N.TRIES = 1,
    alignment = FALSE) {
    # Check

    alns <- deal_with_input_aln(alns)
    # all combinations of inputs
    grid <- tidyr::expand_grid(alns, dbs)
    tbl_list <- purrr::map2(
        .x = grid$alns,
        .y = grid$dbs,
        .f = ~ {
            request_hmmer(
                aln = .x,
                seqdb = .y,
                url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmsearch",
                verbose = TRUE,
                N.TRIES = N.TRIES
            )
        }
    ) %>%
        parse_xml_into_tbl()

    df <- grid %>%
        dplyr::mutate(
            "aln.name" = names(alns),
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
