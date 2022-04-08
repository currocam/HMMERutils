test_that("is_protein_seq", {
  AA_seq <- c("MTEITAAMVKELRESTGAGMMDCKN",
              "MTEITAAMVKELRESTGAGMMDCKN")
  nonAA_seq <- c("MTEITAAMVKELRESTGAGMMDCKN",
                 "----------XX-MMT4")
  is_protein_seq(AA_seq) %>%
    expect_true()
  is_protein_seq(nonAA_seq) %>%
    expect_false()
})
