test_that("is_protein_seq is working", {
    AA_seq <- c(
        "MTEITAAMVKELRESTGAGMMDCKN",
        "MTEITAAMVKELRESTGAGMMDCKN"
    )
    nonAA_seq <- c(
        "MTEITAAMVKELRESTGAGMMDCKN",
        "----------XX-MMT4"
    )
    is_protein_seq(AA_seq) %>%
        expect_true()
    is_protein_seq(nonAA_seq) %>%
        expect_false()
})


test_that("AAMultipleAlignment_to_string is working", {
    aln <- c(
        "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
        "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
        "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
    ) %>%
        Biostrings::AAMultipleAlignment()
    AAMultipleAlignment_to_string(
        c(aln, aln)
    ) %>%
        expect_snapshot_output()
})

test_that("parse_hash_xml is working", {
    xml <- readr::read_file("files/testing_xml.txt") %>%
        XML::xmlParse()
    parse_hash_xml(xml, "///stats") %>%
        expect_snapshot_output()
})

test_that("parse_uuid_xml is working", {
    xml <- readr::read_file("files/testing_xml.txt") %>%
        XML::xmlParse()
    parse_uuid_xml(xml) %>%
        expect_snapshot_output()
})

test_that("get_fullseqfasta_url is working", {
    get_fullseqfasta_url("B1611EA8-B753-11EC-B668-E311E976C163") %>%
        expect_snapshot_output()
})
test_that("get_alignment_url is working", {
    get_alignment_url("B1611EA8-B753-11EC-B668-E311E976C163") %>%
        expect_snapshot_output()
})
