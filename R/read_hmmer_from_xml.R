#' Read the results of a search with HMMER from an XML file.
#'
#' @param xml_file_paths A a character vector the containing filepaths to
#'     XML file downloaded from HMMER.
#' @param algorithm character vector of one containing the algorithm that was
#' used. It can be `phmmer`, `hmmscan`, `hmmsearch`, `jackhammer`.
#' @return An `AnnotatedDataFrame`, consisting of 2 parts, a nested DataFrame
#'  with the search hashes  and the metadata associated to this DataFrame.
#'  Although all available results are available here, we recommend using the
#'  `extract_from_HMMER_data_tbl` function to preprocess the data. If not
#'  indicated, the data will be processed as if it were a sequence search.
#'
#' @examples
#' xml_path <- system.file(
#'     "/extdata/xml_example.xml",
#'     package = "HMMERutils"
#' )
#' read_hmmer_tbl <- read_hmmer_from_xml(xml_path, algorithm = "phmmer")
#' read_hmmer_tbl
#' Biobase::varMetadata(hmmscan_tbl)
#' @export

read_hmmer_from_xml <- function(xml_file_paths, algorithm = "default") {
    check_files_before_read(xml_file_paths)
    tbl_list <- xml_file_paths %>%
        purrr::map(
            purrr::possibly(
              otherwise = list(
                "uuid" = NA,"stats" = NA,"hits" = NA, "domains" = NA),
                ~ {
                    xml <- readr::read_file(.x) %>%
                      XML::xmlParse()
                    list(
                        "uuid" = .x,
                        "stats" = parse_hash_xml(xml, "///stats"),
                        "hits" = parse_hash_xml(xml, "///hits"),
                        "domains" = parse_hash_xml(xml, "///domains") %>%
                          {if(algorithm == "hmmscan") purrr::flatten_dfr(.) else .}
                    )
                }
            )
        ) %>%
        purrr::transpose()
    df <- data.frame("uuid" = purrr::flatten_chr(tbl_list$uuid)) %>%
      dplyr::mutate(
        "stats" = tbl_list$stats,
        "hits" = tbl_list$hits,
        "domains" = tbl_list$domains)
    metaData <- retrieve_hmmer_metadata(colnames(df))

    Biobase::AnnotatedDataFrame(
      data = df[metaData$label],
      varMetadata = metaData %>%
        dplyr::select("labelDescription") %>%
        dplyr::mutate("algorithm" = algorithm))
}

check_files_before_read <- function(files) {
    if (!all(file.exists(files))) {
        stop(
            "File doesn't exist"
        )
    }
}
