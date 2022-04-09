#' Perform a hmmscan search of a protein sequence against a profile-HMM database.
#' @param seqs A vector of characters containing the sequences of the query.
#' @param dbs A character vector containing the target databases. Frequently
#'  used databases are `pfam`, `tigrfam` `gene3d`, `superfamily`, `pirsf` and
#'   `treefam`, but a complete and updated list is available at
#'   \url{https://www.ebi.ac.uk/Tools/hmmer/}.
#' @param verbose A logical, if TRUE details of the download process is printed.
#' @param timeout An integer specifying the number of seconds to wait for the
#'  reply before a time out occurs.
#'
#' @return A nested DataFrame with columns `seqs`, `dbs`, `url`
#'  (HMMER temporary url), `hits`, `stats`, `domains` and, if selected,
#'   `fullseq.fasta.`
#'
#' @section Stats data structure:
#' * `nhits`: 	The number of hits found above reporting thresholds.
#' * `Z`: 	The number of sequences or models in the target database.
#' * `domZ`: 	The number of hits in the target database.
#' * `nmodels` 	The number of models in this search.
#' * `nincluded` 	The number of sequences or models scoring above the significance threshold.
#' * `nreported` 	The number of sequences or models scoring above the reporting threshold
#'
#' @section Sequence data structure:
#' The hits array contains one or more sequences. Tthe redundant sequence information will also be included.
#' * `name`: 	Name of the target (sequence for phmmer/hmmsearch, HMM for hmmscan).
#' * `acc`: 	Accession of the target.
#' * `acc2`: 	Secondary accession of the target.
#' * `id`: 	Identifier of the target.
#' * `desc`: 	Description of the target.
#' * `score`: 	Bit score of the sequence (all domains, without correction)
#' * `pvalue`: 	P-value of the score.
#' * `evalue`: 	E-value of the score.
#' * `nregions`: 	Number of regions evaluated.
#' * `nenvelopes`: 	Number of envelopes handed over for domain definition, null2, alignment, and scoring.
#' * `ndom`: 	Total number of domains identified in this sequence.
#' * `nreported`: 	Number of domains satisfying reporting thresholding.
#' * `nincluded`: 	Number of domains satisfying inclusion thresholding.
#' * `taxid`: 	The NCBI taxonomy identifier of the target (if applicable).
#' * `species`: 	The species name of the target (if applicable).
#' * `kg`: 	The kingdom of life that the target belongs to - based on placing in the NCBI taxonomy tree (if applicable).
#'
#' @section Domain data structure:
#' The domain contains the details of the match, in particular the alignment between the query and the target.
#' * `ienv`: 	Envelope start position.
#' * `jenv`: 	Envelope end position.
#' * `iali`: 	Alignment start position.
#' * `jali`: 	Alignment end position.
#' * `bias`: 	null2 score contribution.
#' * `oasc`: 	Optimal alignment accuracy score.
#' * `bitscore`: 	Overall score in bits, null corrected, if this were the only domain in seq.
#' * `cevalue`: 	Conditional E-value based on the domain correction.
#' * `ievalue`: 	Independent E-value based on the domain correction.
#' * `is_reported`: 	1 if domain meets reporting thresholds.
#' * `is_included`: 	1 if domain meets inclusion thresholds.
#' * `alimodel`: 	Aligned query consensus sequence phmmer and hmmsearch, target hmm for hmmscan.
#' * `alimline`: 	Match line indicating identities, conservation +’s, gaps.
#' * `aliaseq`: 	Aligned target sequence for phmmer and hmmsearch, query for hmmscan.
#' * `alippline`: 	Posterior probability annotation.
#' * `alihmmname`: 	Name of HMM (query sequence for phmmer, alignment for hmmsearch and target hmm for hmmscan).
#' * `alihmmacc`: 	Accession of HMM.
#' * `alihmmdesc`: 	Description of HMM.
#' * `alihmmfrom`: 	Start position on HMM.
#' * `alihmmto`: 	End position on HMM.
#' * `aliM`: 	Length of model.
#' * `alisqname`: 	Name of target sequence (phmmer, hmmscan) or query sequence(hmmscan).
#' * `alisqacc`: 	Accession of sequence.
#' * `alisqdesc`: 	Description of sequence.
#' * `alisqfrom`: 	Start position on sequence.
#' * `alisqto`: 	End position on sequence.
#' * `aliL`: 	Length of sequence.
#'
#' @export
#'
#' @examples
#' hmmscan_tbl <- search_hmmscan(
#'     seqs = "MTEITAAMVKELRESTGAGMMDCKN",
#'     dbs = "pfam",
#'     verbose = TRUE,
#'     timeout = 90
#' )
search_hmmscan <- function(seqs,
    dbs = "pfam",
    verbose = TRUE,
    timeout = 90) {
    # Check

    seqs <- deal_with_input_sequences(seqs)
    # all combinations of inputs
    grid <- tidyr::expand_grid(seqs, dbs)
    tbl_list <- purrr::map2(
        .x = grid$seqs,
        .y = grid$dbs,
        .f = ~ {
            request_hmmer(
                seq = .x,
                hmmdb = .y,
                url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
                verbose = TRUE
            )
        }
    ) %>%
        parse_xml_into_tbl()

    df <- grid %>%
        dplyr::mutate(
            "seq.name" = names(seqs),
            "uuid" = purrr::flatten_chr(tbl_list$uuid),
            "url" = purrr::flatten_chr(tbl_list$url),
            "stats" = tbl_list$stats,
            "hits" = tbl_list$hits,
            "domains" = tbl_list$domains
        )
    class(df) <- c("HMMER_data_tbl", class(df))
    return(df)
}
