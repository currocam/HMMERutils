## code to prepare `example_phmmer` dataset goes here
library(HMMERutils)
library(tidyverse)
phmmer_tbl <- search_phmmer(
  seqs = "MTEITAAMVKELRTGAGMMDCKN",
  seq_names = "1efu_B",
  dbs = c("pdb", "swissprot"),
  verbose = FALSE)
fullfasta_HMMER_tbl <- phmmer_tbl%>%
    extract_from_HMMER_data_tbl() %>%
    add_taxa_to_HMMER_tbl(mode = "local") %>%
    add_fullseq_to_HMMER_tbl(phmmer_tbl$fullfasta.url) %>%
    add_physicochemical_properties_to_HMMER_tbl()
pdata <- Biobase::pData(fullfasta_HMMER_tbl)
pdata <- pdata %>%
  tidyr::drop_na("hits.fullfasta") %>%
  dplyr::slice_sample(n =50)
example_phmmer <- Biobase::AnnotatedDataFrame(pdata, Biobase::varMetadata(fullfasta_HMMER_tbl))
usethis::use_data(example_phmmer, overwrite = TRUE)
