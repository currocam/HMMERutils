testthat::skip("No mocking for add fullseqfasta yet")
testthat::test_that("add fullseqfasta works", {
  search_in_hmmer(
    algorithm = "phmmer",
    seqdb = "pdb",
    seq = ">Seq\nKLRVLGYHNGEWCEAQTKNGQGWVPSNYITPVNSLENSIDKHSWYHGPVSRNAAE"
  ) %>%
    add_sequences_to_hmmer_tbl() %>%
    dplyr::pull("hits.fullfasta") %>%
    testthat::expect_no_error()
})
