## code to prepare `ABL1_homologous` dataset goes here
library(HMMERutils)
xml_path <- system.file(
    "/extdata/ABL_TYROSINE_KINASE.xml",
    package = "HMMERutils"
)
fasta_path <- system.file(
    "/extdata/ABL_TYROSINE_KINASE.fa",
    package = "HMMERutils"
)
ABL1_homologous <- read_hmmer_from_xml(xml_path, fasta_path) %>%
    extract_from_HMMER_data_tbl() %>%
    dplyr::filter(hits.evalue < 0.01) %>%
    dplyr::distinct(hits.name,
        hits.fullseq.fasta,
        .keep_all = TRUE
    ) %>%
    add_taxa_to_HMMER_tbl(mode = "local") %>%
    add_physicochemical_properties_to_HMMER_tbl()
usethis::use_data(ABL1_homologous, overwrite = TRUE)

pairwise_identities_ABL1_homologous <- ABL1_homologous %>%
    dplyr::filter(taxa.species != "Homo sapiens") %>%
    dplyr::distinct(as.factor(hits.fullseq.fasta), .keep_all = TRUE) %>%
    dplyr::pull("hits.fullseq.fasta") %>%
    pairwise_alignment_sequence_identity(
        aln_type = "global",
        pid_type = "PID1",
        allow_parallelization = "multisession"
    )

usethis::use_data(pairwise_identities_ABL1_homologous, overwrite = TRUE)
