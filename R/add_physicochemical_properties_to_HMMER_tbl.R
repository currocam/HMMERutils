#' Add EMBOSS-inspired theoretical physicochemical properties
#'     using the `Peptides` library
#'
#' @param HMMER_tidy_tbl A `HMMER_tidy_tbl`.
#'
#' @return A `HMMER_tidy_tbl`.
#' @export
#'
#' @examples
#' \donttest{
#' xml_path <- system.file(
#'     "/extdata/ABL_TYROSINE_KINASE.xml",
#'     package = "HMMERutils"
#' )
#' fasta_path <- system.file(
#'     "/extdata/ABL_TYROSINE_KINASE.fa",
#'     package = "HMMERutils"
#' )
#' data <- read_hmmer_from_xml(xml_path, fasta_path) %>%
#'     extract_from_HMMER_data_tbl() %>%
#'     add_physicochemical_properties_to_HMMER_tbl()
#' }
add_physicochemical_properties_to_HMMER_tbl <- function(HMMER_tidy_tbl) {
    HMMER_tidy_tbl$hits.fullseq.fasta %>%
        calculate_physicochemical_properties() %>%
        dplyr::rename_with(~ paste0("properties.", .)) %>%
        dplyr::right_join(
            HMMER_tidy_tbl,
            by = c("properties.seqs" = "hits.fullseq.fasta")
        ) %>%
        dplyr::select(-c("properties.id")) %>%
        dplyr::rename("hits.fullseq.fasta" = "properties.seqs")
}
