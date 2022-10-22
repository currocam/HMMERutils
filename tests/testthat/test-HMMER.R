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

testthat::skip("Not mocking yet")
httptest::with_mock_api({
  testthat::test_that("mock add fullseqfasta works", {
    data <- search_in_hmmer(
      algorithm = "phmmer",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    )
    data %>%
      add_sequences_to_hmmer_tbl() %>%
      dplyr::pull("hits.fullfasta")
  })
})
