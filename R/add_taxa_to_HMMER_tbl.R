#' Add taxonomic information to an HMMER_tidy_tbl using `annotate_with_NCBI_taxid`.
#'
#' @param HMMER_tidy_tbl An `AnnotatedDataFrame` obtained through
#'   `extract_from_HMMER_data_tbl`.
#' @param rank_vc A character vector containing the desired taxonomic ranks.
#' If empty, all available taxonomic ranges will be retrieved.
#' @param mode Either "local" or "remote". If "local" you will use a local
#'   database instead of remote resources.  You will not have to download the
#'   database but it is slower.
#'
#' @return An `AnnotatedDataFrame` with new taxonomic parameters.
#' @export
#'
#' @examples
#' xml_path <- system.file(
#'     "/extdata/xml_example.xml",
#'     package = "HMMERutils"
#' )
#' taxa_HMMER_tbl <- read_hmmer_from_xml(xml_path, algorithm = "phmmer")%>%
#'     extract_from_HMMER_data_tbl() %>%
#'     add_taxa_to_HMMER_tbl(mode = "local")
#' taxa_HMMER_tbl
add_taxa_to_HMMER_tbl <- function(HMMER_tidy_tbl,
    mode = "remote",
    rank_vc = NULL) {
  check_AnnotatedDataFrame(HMMER_tidy_tbl)
  pdata <- Biobase::pData(HMMER_tidy_tbl)
  tax.data <- annotate_with_NCBI_taxid(
        taxid = pdata$hits.taxid,
        mode = mode) %>%
        dplyr::rename_with(~ paste0("taxa.", .))
  meta.taxa <- data.frame("label" = colnames(tax.data)) %>%
    dplyr::mutate("labelDescription" = "Taxonomic rank") %>%
    dplyr::filter(.data$label != "taxa.taxid") %>%
    tibble::column_to_rownames("label")
  Biobase::AnnotatedDataFrame(
    data = pdata %>%
      dplyr::left_join(tax.data, by = c("hits.taxid" = "taxa.taxid")),
    varMetadata = rbind(Biobase::varMetadata(HMMER_tidy_tbl), meta.taxa)
  )
}
