#' Add fullseq_fasta information information to an `AnnotatedDataFrame`
#'   by reading fasta files.
#'
#' @param HMMER_tidy_tbl An `AnnotatedDataFrame` obtained through
#'   `extract_from_HMMER_data_tbl`.
#' @param fasta_files A character vector containing either the download urls
#'   (found in the url.fullfasta column) of the files or the path to the files.
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
add_fullseq_to_HMMER_tbl <- function(HMMER_tidy_tbl, fasta_files) {
  check_AnnotatedDataFrame(HMMER_tidy_tbl)
  if (length(fasta_files) != length(unique(HMMER_tidy_tbl$uuid))) {
    stop("The length of fasta_files must be identical to the number of unique",
    "identifiers (uuid) in HMMER_tidy_tbl.")
  }
  fasta_char <- fasta_files %>%
    purrr::map2_dfr(unique(HMMER_tidy_tbl$uuid), .f = ~{

      fasta <- .x %>% get_path__and_read_fasta_file()
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
  # seqs_names <- data$hits.name
  # index_duplicated <- duplicated(seqs_names)
  # seqs_names[index_duplicated] <- paste0(data$hits.name[index_duplicated],
  #                                        "_", data$uuid[index_duplicated])
  # data$hits.fullfasta <- data$hits.fullfasta %>%
  #   magrittr::set_names(seqs_names)
  Biobase::AnnotatedDataFrame(
    data = data,
    varMetadata = rbind(Biobase::varMetadata(HMMER_tidy_tbl), meta)
  )
}

download_fasta_file<- function(fasta_url){
  temp <- tempfile()
  fasta_url %>% utils::download.file(temp, mode = "wb")
  return(temp)
}

get_path__and_read_fasta_file <- function(fasta_file){
  if (file.exists(fasta_file)) {
    fasta_file %>%
      Biostrings::readAAStringSet()%>%
      return()
  }
  else{
    fasta<- fasta_file %>%
      download_fasta_file()%>%
      Biostrings::readAAStringSet()
    file.remove(fasta_file)
    return(fasta)
  }
}

