#' Extracts the sequence identifier from the recognized fasta sequence headers.
#'
#' @param headers A vector of characters
#'
#' @return A vector of characters
#' @export
#'
#' @examples
#' headers <- c(
#'     "gb|M73307|AGMA13GT",
#'     "gb|M73307|AGMA13GT",
#'     "emb|CAM43271.1|",
#'     "sp|P01013|OVAX_CHICK description"
#' )
#' parse_fasta_headers(headers)
parse_fasta_headers <- function(headers) {
    patterns <- paste(
        sep = "|",
        "(?<=lcl\\|).+",
        "(?<=bbs\\|).+",
        "(?<=bbm\\|).+",
        "(?<=gim\\|).+",
        "(?<=gb\\|).+(?=\\|)",
        "(?<=emb\\|).+(?=\\|)",
        "(?<=pir\\|).+",
        "(?<=sp\\|).+",
        "(?<=ref\\|).+(?=\\|)",
        "(?<=gi\\|).+",
        "(?<=dbj\\|).+(?=\\|)",
        "(?<=prf\\|).+",
        "(?<=tpg\\|).+(?=\\|)",
        "(?<=tpe\\|).+(?=\\|)",
        "(?<=tpd\\|).+(?=\\|)",
        "(?<=tr\\|).+"
    )
    dplyr::case_when(
        stringr::str_detect(headers, "pat|pgp|gnl") ~
            gsub("\\|", " ", headers) %>%
            stringr::word(3),
        stringr::str_detect(headers, "pdb") ~
            gsub("\\|", " ", headers) %>%
            {
                paste0(
                    stringr::word(., 2), "_",
                    stringr::word(., 3)
                )
            },
        TRUE ~ stringr::str_extract_all(
            paste0(headers, " "),
            patterns
        ) %>%
            as.character() %>%
            stringr::str_remove(".+\\||\\|") %>%
            stringr::word(1)
    )
}
