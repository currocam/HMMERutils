testthat::skip_if_not_installed("stringi")
mock_hmm_list <- function(filename){
  uuid <- c(stringi::stri_rand_strings(length = 8, n = 1),
    stringi::stri_rand_strings(length = 4, n = 4),
    stringi::stri_rand_strings(length = 12, n = 1))%>%
    paste0(collapse = "-")%>%
    toupper()
  list("uuid" = uuid,
              "content" = readr::read_file(filename)) %>%
    list()
}
set.seed(1)
test_that("parse xml from hmmsearch works", {
  mock_hmm_list("files/hmmsearch_testing.txt") %>%
    parse_xml_into_tbl() %>%
    expect_snapshot_value(style = "json2")
})


test_that("parse xml from phmmer works", {
  mock_hmm_list("files/phmmer_testing.txt") %>%
    parse_xml_into_tbl() %>%
    expect_snapshot_value(style = "json2")
})

test_that("parse xml from hmmscan works", {
  mock_hmm_list("files/hmmscan_testing.txt") %>%
    parse_xml_into_tbl() %>%
    expect_snapshot_value(style = "json2")
})


test_that("parse xml works with vectorization", {
    c(
      mock_hmm_list("files/jackhammer_aln_testing.txt"),
      mock_hmm_list("files/jackhammer_aln_testing.txt")
    ) %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})
