test_that("plot works", {
    vdiffr::expect_doppelganger(
        "A cleveland_dot_plot",
        hmmer_evalues_cleveland_dot_plot(
          HMMERutils::ABL1_homologous,
            threshold = 0.001
        )
    )
})
