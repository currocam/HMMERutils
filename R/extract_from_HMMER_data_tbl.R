#' A function that extracts information from an `AnnotatedDataFrame`
#'   obtained through the `search` family of functions or `read_hmmer_from_xml`
#'   and returns a Tidy `AnnotatedDataFrame`.
#'
#' @param HMMER_data_tbl An `AnnotatedDataFrame` obtained through the `search`
#'   family of functions or `read_hmmer_from_xml`.
#'
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a tidy DataFrame
#'   with one row for each domain identified in the sequences  and the metadata
#'   associated to this DataFrame. In case you want to work with sequences you
#'   could group by hits.name to work only with sequence hits.
#'
#' @export
#'
#' @examples
#' path_to_xml_file <- system.file(
#'     "/extdata/xml_example.xml",
#'     package = "HMMERutils"
#' )
#' data <- read_hmmer_from_xml(path_to_xml_file) %>%
#'     extract_from_HMMER_data_tbl()
extract_from_HMMER_data_tbl <- function(HMMER_data_tbl) {
  check_AnnotatedDataFrame(HMMER_data_tbl)
    pdata <- Biobase::pData(HMMER_data_tbl)
    algorithm <- Biobase::varMetadata(HMMER_data_tbl) %>%
      dplyr::pull("algorithm") %>%
      magrittr::extract2(1)

    df <- list(
      hits = pdata$hits,
      domains = pdata$domains,
      uuid = pdata$uuid) %>%
     purrr::pmap_dfr(.f = ~ {
            hits <- ..1 %>%
                dplyr::rename_with(~ paste0("hits.", .))
            domains <- ..2 %>%
                dplyr::rename_with(~ paste0("domains.", .))
            hits %>%
              {if(algorithm == "hmmscan")
                dplyr::left_join(., domains,
                    by = c("hits.name" = "domains.alihmmname"))
                else dplyr::left_join(., domains,
                    by = c("hits.name" = "domains.alisqname"))}%>%
              dplyr::mutate("uuid" = ..3)
        })

    create_tidy_hmmer_AnnotatedDataFrame(df)
}

check_AnnotatedDataFrame <- function(AnnotatedDataFrame) {
    if (!inherits(AnnotatedDataFrame, "AnnotatedDataFrame") || !methods::validObject(AnnotatedDataFrame)) {
        stop("extract_from_HMMER_data_tbl requires a 'HMMER_data_tbl' object")
    }
}

create_tidy_hmmer_AnnotatedDataFrame <- function(HMMER_data_tbl_df){
  metaData <- system.file(
    "extdata/label_hmmer_descriptions.csv",package = "HMMERutils") %>%
    utils::read.csv() %>%
    dplyr::filter(.data$label %in% colnames(HMMER_data_tbl_df))
  Biobase::AnnotatedDataFrame(
    data = HMMER_data_tbl_df[metaData$label],
    varMetadata = metaData %>%
      dplyr::select("labelDescription")
  )
}
