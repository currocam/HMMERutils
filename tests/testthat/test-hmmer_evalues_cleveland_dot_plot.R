test_that("plot works", {
    data(example_phmmer)
    vdiffr::expect_doppelganger(
        "A cleveland_dot_plot",
        hmmer_evalues_cleveland_dot_plot(
          example_phmmer,
            threshold = 0.001
        )
    )
})
