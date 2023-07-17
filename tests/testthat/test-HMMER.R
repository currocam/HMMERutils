testthat::skip_on_ci()
httptest::with_mock_api({
  testthat::test_that("mock phmmer works", {
    search_in_hmmer(
      algorithm = "phmmer",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("mock hmmscan works", {
    search_in_hmmer(
      algorithm = "hmmscan",
      hmmdb = "pfam",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("mock hmmsearch works", {
    aln <- Biostrings::readAAMultipleAlignment("alignment.fasta") %>%
      Biostrings::unmasked() %>%
      format_AAStringSet_into_hmmer_string()
    search_in_hmmer(
      algorithm = "hmmsearch",
      seqdb = "swissprot",
      seq = aln
    ) %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("mock phmmer with wrong input fails", {
    search_in_hmmer(
      algorithm = "phmmer",
      hmmdb = "pfam",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("mock hmmscan with wrong input fails", {
    search_in_hmmer(
      algorithm = "hmmscan",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("mock hmmsearch with wrong input fails", {
    search_in_hmmer(
      algorithm = "hmmsearch",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    ) %>%
      testthat::expect_snapshot()
  })
})
