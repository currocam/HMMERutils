test_that("It returns correct search rul", {
  return_HMMER_API_search_url("phmmer") %>%
    expect_identical("https://www.ebi.ac.uk/Tools/hmmer/search/phmmer")
})
