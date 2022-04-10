    ## code to prepare `ABL1_homologous` dataset goes here
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
        add_taxa_to_HMMER_tbl(mode = "local") %>%
        add_physicochemical_properties_to_HMMER_tbl()
    usethis::use_data(ABL1_homologous, overwrite = TRUE)
