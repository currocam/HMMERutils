
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HMMERutils

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/currocam/HMMERutils)](https://github.com/currocam/HMMERutils/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/currocam/HMMERutils)](https://github.com/currocam/HMMERutils/pulls)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/HMMERutils.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/HMMERutils)
[![R-CMD-check-bioc](https://github.com/currocam/HMMERutils/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/currocam/HMMERutils/actions)
<!-- badges: end -->

The goal of `HMMERutils` is to …

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `HMMERutils` from
[Bioconductor](http://bioconductor.org/) using the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("HMMERutils")
```

And the development version from
[GitHub](https://github.com/currocam/HMMERutils) with:

``` r
BiocManager::install("currocam/HMMERutils")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library("HMMERutils")
## basic example code
```

## Citation

Below is the citation output from using `citation('HMMERutils')` in R.
Please run this yourself to check for any updates on how to cite
**HMMERutils**.

``` {r
print(citation("HMMERutils"), bibtex = TRUE)
```

Please note that the `HMMERutils` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `HMMERutils` project is released with a
[Contributor Code of
Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Development tools

-   Continuous code testing is possible thanks to [GitHub
    actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
    through *[usethis](https://CRAN.R-project.org/package=usethis)*,
    *[remotes](https://CRAN.R-project.org/package=remotes)*, and
    *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)*
    customized to use [Bioconductor’s docker
    containers](https://www.bioconductor.org/help/docker/) and
    *[BiocCheck](https://bioconductor.org/packages/3.14/BiocCheck)*.
-   Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh) and
    *[covr](https://CRAN.R-project.org/package=covr)*.
-   The [documentation website](http://currocam.github.io/HMMERutils) is
    automatically updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
-   The code is styled automatically thanks to
    *[styler](https://CRAN.R-project.org/package=styler)*.
-   The documentation is formatted thanks to
    *[devtools](https://CRAN.R-project.org/package=devtools)* and
    *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://bioconductor.org/packages/3.14/biocthis)*.
