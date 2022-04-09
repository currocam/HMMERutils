search_hmmsearch <- function(alns,
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
