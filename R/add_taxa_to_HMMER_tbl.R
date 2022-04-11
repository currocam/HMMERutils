#' Add taxonomic information to an HMMER_tidy_tbl using `annotate_with_NCBI_taxid`.
#'
#' @param HMMER_tidy_tbl A `HMMER_tidy_tbl`.
#' @param rank_vc A character vector containing the desired taxonomic ranks. If empty, all available taxonomic ranges will be retrieved.
#' @param mode A character vector, if "local" will use a local database instead of remote resources.  You will not have to download the database but it is slower.
#'
#' @return A `HMMER_tidy_tbl`.
#' @export
#'
#' @examples
#' xml_path <- system.file(
#'     "/extdata/ABL_TYROSINE_KINASE.xml",
#'     package = "HMMERutils"
#' )
#' data <- read_hmmer_from_xml(xml_path) %>%
#'     extract_from_HMMER_data_tbl() %>%
#'     add_taxa_to_HMMER_tbl(mode = "local")
add_taxa_to_HMMER_tbl <- function(HMMER_tidy_tbl,
    mode = "remote",
    rank_vc = NULL) {
    annotate_with_NCBI_taxid(
        taxid = HMMER_tidy_tbl$hits.taxid,
        mode = mode
    ) %>%
        dplyr::rename_with(~ paste0("taxa.", .)) %>%
        dplyr::right_join(HMMER_tidy_tbl, by = c("taxa.taxid" = "hits.taxid"))
}
