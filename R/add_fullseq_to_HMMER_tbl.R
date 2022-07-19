#' Add fullseq_fasta information information to an `AnnotatedDataFrame`
#'   by reading fasta files.
#'
#' @param HMMER_tidy_tbl An `AnnotatedDataFrame` obtained through
#'   `extract_from_HMMER_data_tbl`.
#' @param fasta_files A character vector containing either the download urls
#'   (found in the url.fullfasta column) of the files or the path to the files.
#' @param N.TRIES An integer with the maximum number of attempts to read/download the file.
#'
#' @return An `AnnotatedDataFrame` with a new column with the fasta sequences.
#' @export
#'
#' @examples
#' phmmer_tbl <- search_phmmer(
#'   seqs = "MTEITAAMVKELRTGAGMMDCKN",
#'   seq_names = "1efu_B",
#'   dbs = "pdb",
#'   verbose = FALSE)
#' fullfasta_HMMER_tbl <- phmmer_tbl%>%
#'     extract_from_HMMER_data_tbl() %>%
#'     add_fullseq_to_HMMER_tbl(phmmer_tbl$fullfasta.url)
#' fullfasta_HMMER_tbl
add_fullseq_to_HMMER_tbl <- function(HMMER_tidy_tbl, fasta_files = NULL, N.TRIES = 2) {
  check_AnnotatedDataFrame(HMMER_tidy_tbl)

  if (is.null(fasta_files)) {
    fasta_files <-HMMER_tidy_tbl$uuid %>%
      unique() %>%
      create_download_url_for_hmmer("fullfasta")
  }
  if (length(fasta_files) != length(unique(HMMER_tidy_tbl$uuid))) {
    stop("The length of fasta_files must be identical to the number of unique",
    "identifiers (uuid) in HMMER_tidy_tbl.")
  }
  fasta_char <- fasta_files %>%
    purrr::map_chr(~download_if_url(.x , N.TRIES))%>%
    purrr::map2_dfr(unique(HMMER_tidy_tbl$uuid), .f = ~{

      fasta <- .x %>% Biostrings::readAAStringSet()
      data.frame(
        "hits.fullfasta" = as.character(fasta)) %>%
        dplyr::mutate("uuid" = .y,
                      "hits.name" = names(fasta))
    })
  meta <- data.frame("label" = "hits.fullfasta") %>%
    dplyr::mutate("labelDescription" = "Full length sequences for search hits.") %>%
    tibble::column_to_rownames("label")
  data <- Biobase::pData(HMMER_tidy_tbl) %>%
    dplyr::full_join(fasta_char,
                     by = c("uuid" = "uuid", "hits.name" = "hits.name"))
  Biobase::AnnotatedDataFrame(
    data = data,
    varMetadata = rbind(Biobase::varMetadata(HMMER_tidy_tbl), meta)
  )
}

download_fasta_file<- function(fasta_url){
  temp <- tempfile()
  fasta_url %>% utils::download.file(temp, mode = "wb",method="libcurl")
  return(temp)
}

download_if_url <- function(path, N.TRIES) {
  if (file.exists(path)) {
    return(path)
  }
  i <- 0
  while (i<N.TRIES) {
    i <- i + 1
    new_path <- tryCatch(download_fasta_file(path),
                     error = function(e) e)
    if (!inherits(new_path, "error")) {
      return(new_path)
    }
  }
    stop(path)
}
