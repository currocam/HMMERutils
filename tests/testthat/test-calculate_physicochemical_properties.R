    test_that("calculate emboss works", {
        "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC" %>%
            calculate_physicochemical_properties() %>%
            testthat::expect_snapshot_value(style = "deparse")
    })
    test_that("calculate emboss works vect", {
        Biostrings::AAStringSet(
            c(
                "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
                "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC"
            )
        ) %>%
            calculate_physicochemical_properties() %>%
            testthat::expect_snapshot_value(style = "deparse")
    })
