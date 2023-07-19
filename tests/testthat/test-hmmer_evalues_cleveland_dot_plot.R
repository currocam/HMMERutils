test_that("plot works", {
  data("phmmer_2abl")
  vdiffr::expect_doppelganger(
    "A cleveland_dot_plot",
    hmmer_evalues_cleveland_dot_plot(
      phmmer_2abl,
      threshold = 0.001
    )
  )
})
