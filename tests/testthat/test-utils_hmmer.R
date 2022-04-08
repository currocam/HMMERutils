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


test_that("parse_hash_xml is working", {
  xml <- XML::xmlParse(file = "testing_xml.xml")
  parse_hash_xml(xml, "///stats") %>%
    expect_snapshot_output()
})
