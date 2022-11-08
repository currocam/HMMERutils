httptest::with_mock_api({
  testthat::test_that("Test that filter hmmer works hits evalue", {

    data(phmmer_2abl)
    phmmer_2abl %>%
      filter_hmmer(by = "hits.evalue") %>%
      dplyr::select("hits.evalue") %>%
      testthat::expect_snapshot()
  })
})


httptest::with_mock_api({
  testthat::test_that("Test that filter hmmer works hits domains cevalue", {

    data(phmmer_2abl)
    phmmer_2abl %>%
      filter_hmmer(by = "domains.cevalue") %>%
      dplyr::select("domains.cevalue") %>%
      testthat::expect_snapshot()
  })
})

httptest::with_mock_api({
  testthat::test_that("Test that filter hmmer works hits domains ievalue", {

    data(phmmer_2abl)
    phmmer_2abl %>%
      filter_hmmer(by = "domains.ievalue") %>%
      dplyr::select("domains.ievalue") %>%
      testthat::expect_snapshot()
  })
})
