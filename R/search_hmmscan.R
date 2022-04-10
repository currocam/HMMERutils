#' hmmscan search of a protein sequence against a profile-HMM database.
#' @param seqs A vector of characters containing the sequences of the query.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `pfam`, `tigrfam` `gene3d`, `superfamily`, `pirsf` and
#'   `treefam`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout An integer specifying the number of seconds to wait for the
#'  reply before a time out occurs.
#'
#' @return A nested DataFrame with columns `seqs`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and,
#'   if selected, `fullseq.fasta.`
#'
#' @seealso \code{\link{ABL1_homologous}} for a detailed description of
#'  the meaning of the different variables.
#'
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' try(
#'     hmmscan_tbl <- search_hmmscan(
#'         seqs = "MTEITAAMVKELRESTGAGMMDCKN",
#'         dbs = "pfam",
#'         verbose = FALSE,
#'         timeout = 15
#'     )
#' )
search_hmmscan <- function(seqs,
    dbs = "pfam",
    verbose = TRUE,
    timeout = 90) {
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
                hmmdb = .y,
                url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
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
    class(df) <- c("HMMER_data_tbl", class(df))
    return(df)
}
