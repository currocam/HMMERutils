#' A function that extracts information from `HMMER_data_tbl`, allows to perform some common tasks and returns a Tidy DataFrame.
#'
#' @param HMMER_data_tbl A DataFrame of subclass `HMMER_data_tbl`, obtained through the `search` family of functions or `read_hmmer_from_xml`.
#' @param id_column A character vector with as many elements as rows in HMMER_data_tbl and that will be used to create the `id` column.
#'
#' @return A DataFrame of subclass `HMMER_data_tbl_tidy`. It has as many rows as identified domains.
#' @section Sequence data structure:
#' Variables beginning with "hits." have been extracted from the hash
#'    corresponding to the sequences. Remember that there are as many rows as
#'    there are domains identified, not per sequence. Therefore, these
#'    variables will be duplicated, for example, for a sequence in which 2
#'    domains are identified.
#'
#' * `hits.name`: 	Name of the target (sequence for phmmer/hmmsearch, HMM for hmmscan).
#' * `hits.acc`: 	Accession of the target.
#' * `hits.acc2`: 	Secondary accession of the target.
#' * `hits.id`: 	Identifier of the target.
#' * `hits.desc`: 	Description of the target.
#' * `hits.score`: 	Bit score of the sequence (all domains, without correction)
#' * `hits.pvalue`: 	P-value of the score.
#' * `hits.evalue`: 	E-value of the score.
#' * `hits.nregions`: 	Number of regions evaluated.
#' * `hits.nenvelopes`: 	Number of envelopes handed over for domain definition, null2, alignment, and scoring.
#' * `hits.ndom`: 	Total number of domains identified in this sequence.
#' * `hits.nreported`: 	Number of domains satisfying reporting thresholding.
#' * `hits.nincluded`: 	Number of domains satisfying inclusion thresholding.
#' * `hits.taxid`: 	The NCBI taxonomy identifier of the target (if applicable).
#' * `hits.species`: 	The species name of the target (if applicable).
#' * `hits.kg`: 	The kingdom of life that the target belongs to - based on placing in the NCBI taxonomy tree (if applicable).
#'
#' @section Domain data structure:
#' Variables beginning with "domains." have been extracted from the hash domains.
#' * `domains.ienv`: 	Envelope start position.
#' * `domains.jenv`: 	Envelope end position.
#' * `domains.iali`: 	Alignment start position.
#' * `domains.jali`: 	Alignment end position.
#' * `domains.bias`: 	null2 score contribution.
#' * `domains.oasc`: 	Optimal alignment accuracy score.
#' * `domains.bitscore`: 	Overall score in bits, null corrected, if this were the only domain in seq.
#' * `domains.cevalue`: 	Conditional E-value based on the domain correction.
#' * `domains.ievalue`: 	Independent E-value based on the domain correction.
#' * `domains.is_reported`: 	1 if domain meets reporting thresholds.
#' * `domains.is_included`: 	1 if domain meets inclusion thresholds.
#' * `domains.alimodel`: 	Aligned query consensus sequence phmmer and hmmsearch, target hmm for hmmscan.
#' * `domains.alimline`: 	Match line indicating identities, conservation +’s, gaps.
#' * `domains.aliaseq`: 	Aligned target sequence for phmmer and hmmsearch, query for hmmscan.
#' * `domains.alippline`: 	Posterior probability annotation.
#' * `domains.alihmmname`: 	Name of HMM (query sequence for phmmer, alignment for hmmsearch and target hmm for hmmscan).
#' * `domains.alihmmacc`: 	Accession of HMM.
#' * `domains.alihmmdesc`: 	Description of HMM.
#' * `domains.alihmmfrom`: 	Start position on HMM.
#' * `domains.alihmmto`: 	End position on HMM.
#' * `domains.aliM`: 	Length of model.
#' * `domains.alisqname`: 	Name of target sequence (phmmer, hmmscan) or query sequence(hmmscan).
#' * `domains.alisqacc`: 	Accession of sequence.
#' * `domains.alisqdesc`: 	Description of sequence.
#' * `domains.alisqfrom`: 	Start position on sequence.
#' * `domains.alisqto`: 	End position on sequence.
#' * `domains.aliL`: 	Length of sequence.
#'
#' @section Taxonomic data structure:
#' If annotate_taxonomic = "local" or annotate_taxonomic = "remote" is selected,
#'  as many columns as available taxonomic categories will be included. All of them will have in common that they will start with "taxa".
#' @section Theoretical physicochemical properties data structure:
#' If calculate_physicochemical_properties = TRUE the following columns will be included.
#'  All of them will have in common that they will start with "properties".
#' * `properties.molecular.weight`: sum of the masses of each atom constituting a
#'    molecule (Da) using the same formulas and weights as ExPASy's.
#' *  `properties.charge`: net charge of a protein sequence based on the
#'    Henderson-Hasselbalch equation using Lehninger pKa scale.
#' *  `properties.pI`:  isoelectric point calculated as in EMBOSS PEPSTATS.
#' * `properties.mz`: mass over charge ratio (m/z) for peptides, as measured in mass spectrometry.
#' * `properties.aIndex`: aliphatic index of a protein. The aindex is defined as the
#'    relative volume occupied by aliphatic side chains (Alanine, Valine,
#'    Isoleucine, and Leucine). It may be regarded as a positive factor
#'    for the increase of thermostability of globular proteins.
#' * `properties.boman`: potential protein interaction index . The index is equal to the
#'  sum of the solubility values for all residues in a sequence, it might give
#'  an overall estimate of the potential of a peptide to bind to membranes or
#'  other proteins as receptors, to normalize it is divided by the number of
#'  residues. A protein have high binding potential if the index value is
#'  higher than 2.48.
#' * `properties.hydrophobicity`: GRAVY hydrophobicity index of an amino acids sequence using
#'   KyteDoolittle hydophobicity scale.
#' * `properties.instaIndex`: Guruprasad's instability index. This index predicts the stability
#'    of a protein based on its amino acid composition, a protein whose instability
#'     index is smaller than 40 is predicted as stable, a value above 40 predicts
#'      that the protein may be unstable.
#' * `properties.STYNQW`: Percentage of amino acids (S + T + Y + N + Q + W)
#' * `properties.Tiny`: Percentage of amino acids (A + C + G + S + T)
#' * `properties.Small`: Percentage of amino acids (A + B + C + D + G + N + P + S + T + V)
#' * `properties.Aliphatic`: Percentage of amino acids (A + I + L + V)
#' * `properties.Aromatic`: Percentage of amino acids (F + H + W + Y)
#' * `properties.Non-polar`: Percentage of amino acids (A + C + F + G + I + L + M + P + V + W + Y)
#' * `properties.Polar`: Percentage of amino acids (D + E + H + K + N + Q + R + S + T + Z)
#' * `properties.Charged`: Percentage of amino acids (B + D + E + H + K + R + Z)
#' * `properties.Basic`: Percentage of amino acids (H + K + R)
#'
#' @export
#'
#' @examples
#' xml_path <- system.file(
#'     "/extdata/ABL_TYROSINE_KINASE.xml",
#'     package = "HMMERutils"
#' )
#' data <- read_hmmer_from_xml(xml_path) %>%
#'     extract_from_HMMER_data_tbl()
extract_from_HMMER_data_tbl <- function(HMMER_data_tbl,
    id_column = NULL) {
    check_HMMER_tbl_before_extract(HMMER_data_tbl, id_column)
    names(HMMER_data_tbl$hits) <- id_column
    names(HMMER_data_tbl$domains) <- id_column

    df <- purrr::map2_dfr(
        .x = HMMER_data_tbl$hits,
        .y = HMMER_data_tbl$domains,
        .id = "id",
        .f = ~ {
            hits <- .x %>%
                dplyr::rename_with(~ paste0("hits.", .))
            domains <- .y %>%
                dplyr::rename_with(~ paste0("domains.", .))
            row <- hits %>%
                dplyr::left_join(domains,
                    by = c("hits.name" = "domains.alisqname")
                )
        }
    )
    if ("fullseq.fasta" %in% names(HMMER_data_tbl)) {
        seqs <- extract_sequences(
            HMMER_data_tbl,
            seq_column = HMMER_data_tbl$fullseq.fasta,
            column_name = "fullseq.fasta",
            id_column = id_column
        )
        df <- df %>%
            dplyr::left_join(seqs,
                by = c("id" = "id", "hits.name" = "hits.name")
            )
    }
    class(df) <- c("HMMER_tidy_tbl", class(df))
    return(df)
}

check_HMMER_tbl_before_extract <- function(HMMER_data_tbl, id_column) {
    if (!inherits(HMMER_data_tbl, "HMMER_data_tbl")) {
        stop("extract_from_HMMER_data_tbl requires a 'HMMER_data_tbl' object")
    }
    if (!all(c("hits", "stats", "domains") %in% colnames(HMMER_data_tbl))) {
        stop("`HMMER_data_tbl` is incorrectly formatted. ")
    }
    if (!is.null(id_column) &&
        (length(rownames(HMMER_data_tbl)) != length(id_column))) {
        stop(
            "If added, id_column must have as many elements",
            "as rows in `HMMER_data_tbl.`"
        )
    }
    if (any(is.na(c(HMMER_data_tbl$hits, HMMER_data_tbl$domains)))) {
        stop(
            "NA has been found in `HMMER_data_tbl.` ",
            "Have you filtered the rows with NA results before",
            "using this function?"
        )
    }
}
