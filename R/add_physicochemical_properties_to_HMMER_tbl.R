#' Add EMBOSS-inspired theoretical physicochemical properties
#' using the `Peptides` library to an `AnnotatedDataFrame`
#'
#' @param data A Data Frame containig the indicated
#' column with protein sequences.
#' @param colname A single character vector with the
#' name of the column with the protein sequences.
#'
#' This documentation is based on the following documentation:
#' https://github.com/dosorio/Peptides/
#'
#' @section Theoretical properties:
#' - molecular.weight: sum of the masses of each atom constituting a
#' molecule (Da) using the same formulas and weights as ExPASy's.
#' - charge: net charge of a protein sequence based on the
#' Henderson-Hasselbalch equation using Lehninger pKa scale.
#' - pI:  isoelectric point calculated as in EMBOSS PEPSTATS.
#' - mz: mass over charge ratio (m/z) for peptides,
#'  as measured in mass spectrometry.
#' - aIndex: aliphatic index of a protein. The aindex is defined as the
#'  relative volume occupied by aliphatic side chains (Alanine, Valine,
#'  Isoleucine, and Leucine). It may be regarded as a positive factor
#'  for the increase of thermostability of globular proteins.
#' - boman: potential protein interaction index . The index is equal to the
#'  sum of the solubility values for all residues in a sequence, it might give
#'  an overall estimate of the potential of a peptide to bind to membranes or
#'  other proteins as receptors, to normalize it is divided by the number of
#'  residues. A protein have high binding potential if the index value is
#'  higher than 2.48.
#' - hydrophobicity: GRAVY hydrophobicity index of an amino acids sequence using
#'   KyteDoolittle hydophobicity scale.
#' - instaIndex: Guruprasad's instability index.
#' This index predicts the stability of a protein based
#'  on its amino acid composition, a protein whose instability
#' index is smaller than 40 is predicted as stable, a value
#' above 40 predicts that the protein may be unstable.
#' - STYNQW: Percentage of amino acids (S + T + Y + N + Q + W)
#' - Tiny: Percentage of amino acids (A + C + G + S + T)
#' - Small: Percentage of amino acids (A + B + C + D + G + N + P + S + T + V)
#' - Aliphatic: Percentage of amino acids (A + I + L + V)
#' - Aromatic: Percentage of amino acids (F + H + W + Y)
#' - Nonpolar`: Percentage of amino acids
#'  (A + C + F + G + I + L + M + P + V + W + Y)
#' - Polar: Percentage of amino acids (D + E + H + K + N + Q + R + S + T + Z)
#' - Charged: Percentage of amino acids (B + D + E + H + K + R + Z)
#' - Basic: Percentage of amino acids (H + K + R)
#' - Acidic: Percentage of amino acids (B + D + E + Z)
#' @return A Data Frame with new columns with
#'  the theoretical physicochemical properties
#' @export
#'
add_physicochemical_properties_to_HMMER_tbl <- function(
    data, colname = "hits.fullfasta") {
    if (!requireNamespace("Peptides", quietly = TRUE)) {
        stop("Package \"Peptides\" must be installed to use this function.",
            call. = FALSE
        )
    }
    group_var <- rlang::sym(colname)
    inner_function <- purrr::possibly(
        otherwise = NULL,
        function(x) {
            calculate_peptides(x) %>%
                dplyr::mutate(
                    "molecular.weight" = Peptides::mw(x), 
                    "charge" = Peptides::charge(x),
                    "pI" = Peptides::pI(x), "mz" = Peptides::mz(x),
                    "aIndex" = Peptides::aIndex(x), 
                    "boman" = Peptides::boman(x),
                    "hydrophobicity" = Peptides::hydrophobicity(x),
                    "instaIndex" = Peptides::instaIndex(x),
                    "STYNQW" = stringr::str_count(x, "S|T|Y|N|Q|Q") / nchar(x)
                ) %>%
                dplyr::rename_with(~ paste0("properties.", .))
        }
    )
    data %>%
        dplyr::group_by(!!group_var) %>%
        dplyr::group_split() %>%
        purrr::map_dfr(function(x) {
            x %>% dplyr::bind_cols(inner_function(x[[colname]][[1]]))
        })
}

calculate_peptides <- function(y) {
    Peptides::aaComp(y) %>%
        purrr::map_dfr(~ {
            as.data.frame(.x) %>%
                tibble::rownames_to_column("properties") %>%
                dplyr::rename("Percentage" = "Mole%") %>%
                dplyr::select(c("Percentage", "properties")) %>%
                tidyr::pivot_wider(names_from = "properties", 
                values_from = c("Percentage")) %>%
                dplyr::mutate(
                    dplyr::across(where(is.numeric), ~ .x / 100)
                )
        })
}
