## code to prepare `phmmer_2abl` dataset goes here
library(magrittr)
Biostrings::readAAStringSet("https://www.rcsb.org/fasta/entry/2ABL") %>%
  as.character() %>%
  HMMERutils::search_phmmer("swissprot") -> phmmer_2abl

phmmer_2abl <- phmmer_2abl %>%
  HMMERutils::add_sequences_to_hmmer_tbl()%>%
  dplyr::sample_n(25)
usethis::use_data(phmmer_2abl, overwrite = TRUE)

Biostrings::readAAStringSet("https://www.rcsb.org/fasta/entry/2ABL") %>%
  as.character() %>%
  HMMERutils::search_hmmscan("pfam") -> hmmscan_2abl

usethis::use_data(hmmscan_2abl, overwrite = TRUE)
