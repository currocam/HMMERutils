#' Add EMBOSS-inspired theoretical physicochemical properties.
#'     using the `Peptides` library to an `AnnotatedDataFrame`
#'
#' @param HMMER_tidy_tbl An `AnnotatedDataFrame` obtained through
#'   `extract_from_HMMER_data_tbl` and `add_fullseq_to_HMMER_tbl`.
#'
#' @return An `AnnotatedDataFrame` with new columns with the theoretical physicochemical properties
#' @export
#'
#' @examples
#' data(example_phmmer)
#' example_phmmer_with_physicochemical_properties <- example_phmmer %>%
#'     add_physicochemical_properties_to_HMMER_tbl()
#' example_phmmer_with_physicochemical_properties
add_physicochemical_properties_to_HMMER_tbl <- function(HMMER_tidy_tbl) {
   properties <-  HMMER_tidy_tbl$hits.fullfasta %>%
     magrittr::set_names(HMMER_tidy_tbl$hits.name) %>%
     stats::na.omit() %>%
     calculate_physicochemical_properties() %>%
     dplyr::rename_with(~ paste0("properties.", .)) %>%
     dplyr::select(-c("properties.id"))
   metaData <- system.file(
     "extdata/label_hmmer_descriptions.csv",package = "HMMERutils") %>%
     utils::read.csv() %>%
     dplyr::filter(.data$label %in% colnames(properties)) %>%
     tibble::column_to_rownames("label")
   df <- Biobase::pData(HMMER_tidy_tbl) %>%
     dplyr::left_join(
       properties,
       by = c("hits.fullfasta" = "properties.seqs"))
   Biobase::AnnotatedDataFrame(
     data = df,
     varMetadata = rbind(Biobase::varMetadata(HMMER_tidy_tbl), metaData))
}
