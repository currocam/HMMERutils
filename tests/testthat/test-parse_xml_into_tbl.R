test_that("parse xml from hmmsearch works", {
    readr::read_file("files/hmmsearch_testing.txt") %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})


test_that("parse xml from phmmer works", {
    readr::read_file("files/phmmer_testing.txt") %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})

test_that("parse xml from hmmscan works", {
    readr::read_file("files/hmmscan_testing.txt") %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})

test_that("parse xml from jackhammer works with seq", {
    readr::read_file("files/hmmscan_testing.txt") %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})

test_that("parse xml from jackhammer works with aln", {
    readr::read_file("files/jackhammer_aln_testing.txt") %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})

test_that("parse xml works with vectorization", {
    c(
        readr::read_file("files/jackhammer_aln_testing.txt"),
        readr::read_file("files/jackhammer_aln_testing.txt")
    ) %>%
        parse_xml_into_tbl() %>%
        expect_snapshot_value(style = "json2")
})
