test_that("base request works", {
  hmmer_request(algo = "phmmer", seq = "AAACATT", seqdb = "swissprot") |>
    testthat::expect_snapshot()
})

test_that("base request fails when both seqdb and hmmdb", {
  hmmer_request(algo = "phmmer", seq = "AAACATT",hmmdb = "pfam", seqdb = "swissprot") |>
    testthat::expect_snapshot_error()
})
