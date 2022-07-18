testthat::skip(message = "Skip request to HMMER")

aln <- c(
    "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
    "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
    "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
) %>%
    Biostrings::AAMultipleAlignment()
seq <- c("MTEITAAMVKELRESTGAGMMDCKN")

test_that("hmmsearch works", {
  search_hmmsearch(
    alns = aln,
    dbs = "pdb",
  ) %>%
  expect_snapshot_output()
})

test_that("phmmer works", {
  search_phmmer(seqs = seq)%>%
    expect_snapshot_output()
})

test_that("hmmscan works", {
  search_hmmscan(seq)%>%
    expect_snapshot_output()
})






