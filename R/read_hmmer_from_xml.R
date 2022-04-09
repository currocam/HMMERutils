#' Read the results of a search with HMMER from an XML file and, optionally,
#'    from a fullseq-fasta file and/or an alignment.
#'
#' @param xml_file_paths A a character vector the containing filepaths to
#'     XML file.
#' @param fullseq_fasta_paths If desired, a character vector containing
#'    the paths to the fullseq-fasta file. By default, `NULL`.
#' @param alignment_fasta_paths If desired, a character vector containing
#'     the paths to the fasta alignment file. By default, `NULL`.
#'
#' @return A nested DataFrame with columns `hits`, `stats`, `domains` and,
#'     if selected, `fullseq.fasta` and `alignment`.
#'
#' @section Stats data structure:
#' * `nhits`: 	The number of hits found above reporting thresholds.
#' * `Z`: 	The number of sequences or models in the target database.
#' * `domZ`: 	The number of hits in the target database.
#' * `nmodels` 	The number of models in this search.
#' * `nincluded` 	The number of sequences or models scoring above the
#'    significance threshold.
#' * `nreported` 	The number of sequences or models scoring above the
#'    reporting threshold
#'
#' @return A nested DataFrame with columns `seqs`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and,
#'   if selected, `fullseq.fasta.`
#'
read_hmmer_from_xml <- function(xml_file_paths,
    fullseq_fasta_paths = NULL,
    alignment_fasta_paths = NULL) {
    if (!all(file.exists(xml_file_paths))) {
        stop(
            "`alignment_fasta_paths` must be a character ",
            "vector of paths to alignment fasta files."
        )
    }
    if (!all(file.exists(fullseq_fasta_paths)) && !is.null(fullseq_fasta_paths)) {
        stop(
            "`alignment_fasta_paths` must be a character ",
            "vector of paths to alignment fasta files."
        )
    }
    if (!all(file.exists(alignment_fasta_paths)) && !is.null(alignment_fasta_paths)) {
        stop(
            "`alignment_fasta_paths` must be a character ",
            "vector of paths to alignment fasta files."
        )
    }

    tbl_list <- xml_file_paths %>%
        purrr::map_chr(~ readr::read_file(.x)) %>%
        purrr::map(
            purrr::possibly(
                otherwise = list(
                    "uuid" = NA,
                    "url" = NA,
                    "stats" = NA,
                    "hits" = NA,
                    "domains" = NA
                ),
                ~ {
                    xml <- XML::xmlParse(.x)
                    list(
                        "stats" = parse_hash_xml(xml, "///stats"),
                        "hits" = parse_hash_xml(xml, "///hits"),
                        "domains" = parse_hash_xml(xml, "///domains") %>%
                            {
                                if (is(., "list")) purrr::flatten_dfr(.) else .
                            }
                    )
                }
            )
        ) %>%
        purrr::transpose()

    df <- tibble::tibble(
        "file.name" = xml_file_paths,
        "stats" = tbl_list$stats,
        "hits" = tbl_list$hits,
        "domains" = tbl_list$domains
    )
    if (!is.null(fullseq_fasta_paths)) {
        df <- df %>%
            dplyr::mutate(
                "fullseq.fasta" = fullseq_fasta_paths %>%
                    purrr::map(~ Biostrings::readAAStringSet(.))
            )
    }
    if (!is.null(alignment_fasta_paths)) {
        df <- df %>%
            dplyr::mutate(
                "alignment" = alignment_fasta_paths %>%
                    purrr::map(~ Biostrings::readAAMultipleAlignment(.))
            )
    }
    return(df)
}
