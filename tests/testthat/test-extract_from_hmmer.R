httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with phmmer and pdb", {
    data <- search_in_hmmer(
      algorithm = "phmmer",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    )
    data2 <- data %>%
      extract_from_hmmer()
    testthat::expect_equal(sum(data$hits.ndom), nrow(data2)) 
  })
})


httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with hmmscan and pfam", {
    data <- search_in_hmmer(
      algorithm = "hmmscan",
      hmmdb = "pfam",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    )
    data2 <- data %>%
      extract_from_hmmer()
  testthat::expect_equal(sum(data$hits.ndom), nrow(data2)) 
  })
})



httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with hmmscan and pfam", {
    data <- Biostrings::readAAMultipleAlignment("alignment.fasta") %>%
      search_hmmsearch(seqdb = "swissprot")
    data2 <- data %>%
      extract_from_hmmer()
    testthat::expect_equal(sum(data$hits.ndom), nrow(data2)) 
  })
})

skip("Not implemented yet")
httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with phmmer and pdb for extract pdbs", {
    data <- search_in_hmmer(
      algorithm = "phmmer",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    )
    data2 <- data %>%
      extract_from_hmmer("hits.pdbs") %>%
      testthat::expect_no_error()
  })
})

httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with phmmer and pdb for extract pdbs", {
    data <- search_in_hmmer(
      algorithm = "phmmer",
      seqdb = "pdb",
      seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
    )
    data2 <- data %>%
      extract_from_hmmer("hits.seqs") %>%
      testthat::expect_no_error()
  })
})

httptest::with_mock_api({
  testthat::test_that("Test that extract hmmer works with hmmscan and pfam", {
    data <- Biostrings::readAAMultipleAlignment("alignment.fasta") %>%
      search_hmmsearch(seqdb = "swissprot")
    data2 <- data %>%
      extract_from_hmmer("hits.pdbs") %>%
      testthat::expect_no_error()
  })
})
