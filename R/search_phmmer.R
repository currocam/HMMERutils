#' Perform a phmmer search of a protein sequence against a protein sequence database.
#'
#' @param seqs A vector of characters containing the sequences of the query.
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
#'
#' @return A nested DataFrame with columns `seqs`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and, if selected,
#'   `fullseq.fasta.` and `alignment`.
#' @examples
#' \donttest{
#' phmmer_tbl <- search_phmmer(
#'     seqs = "MTEITAAMVKELRTGAGMMDCKN",
#'     dbs = "pdb",
#'     verbose = FALSE,
#'     timeout = 90
#' )
#' }
#' @export

search_phmmer <- function(seqs,
    dbs = "swissprot",
    fullseqfasta = TRUE,
    verbose = TRUE,
    timeout = 90,
    alignment = FALSE) {
    # Check
    seqs <- deal_with_input_sequences(seqs)
    # all combinations of inputs
    grid <- tidyr::expand_grid(seqs, dbs)
    tbl_list <- purrr::map2(
        .x = grid$seqs,
        .y = grid$dbs,
        .f = ~ {
            request_hmmer(
                seq = .x,
                seqdb = .y,
                url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
                verbose = TRUE
            )
        }
    ) %>%
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
