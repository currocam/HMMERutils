test_that("add_hmmer_urls works", {
    df <- data.frame(number = c("21", "22"))
    uuid <- c(
        "524C447A-C251-11EC-B5B5-745DF75AEC3D",
        "524C447A-C251-11EC-B5B5-745DF75AEC3D"
    )
    add_hmmer_urls(df, uuid, type = "hmmscan") %>%
        testthat::expect_snapshot_output()
    add_hmmer_urls(df, uuid, type = "phmmer") %>%
        testthat::expect_snapshot_output()
})
