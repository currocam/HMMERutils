#' Information about 694 sequences homologous to ABL1.
#'
#' A dataset containing 694 sequences homologous to ABL1, a
#'  cytoplasmic and nuclear protein tyrosine kinase that has
#'  been implicated in processes of cell differentiation, cell
#'  division, cell adhesion and stress response such as DNA repair.
#'
#' They were found using PHMMER, and contain information on the
#'   taxonomy of the species to which they belong, theoretical
#'   physical and chemical properties calculated on the basis of
#'    the sequence and other variables returned by HMMER.
#'
#' @format A data frame with 694 rows and 127 variables:
#'
#' @section Sequence data structure:
#' Variables beginning with "hits." have been extracted from the hash
#'    corresponding to the sequences. Remember that there are as many rows as
#'    there are domains identified, not per sequence. Therefore, these
#'    variables will be duplicated, for example, for a sequence in which 2
#'    domains are identified.
#'
#' * `hits.name`: 	Name of the target (sequence for phmmer/hmmsearch,
#'    HMM for hmmscan).
#' * `hits.acc`: 	Accession of the target.
#' * `hits.acc2`: 	Secondary accession of the target.
#' * `hits.id`: 	Identifier of the target.
#' * `hits.desc`: 	Description of the target.
#' * `hits.score`: 	Bit score of the sequence (all domains, without
#'    correction)
#' * `hits.pvalue`: 	P-value of the score.
#' * `hits.evalue`: 	E-value of the score.
#' * `hits.nregions`: 	Number of regions evaluated.
#' * `hits.nenvelopes`: 	Number of envelopes handed over for domain
#'    definition, null2, alignment, and scoring.
#' * `hits.ndom`: 	Total number of domains identified in this sequence.
#' * `hits.nreported`: 	Number of domains satisfying
#'    reporting thresholding.
#' * `hits.nincluded`: 	Number of domains satisfying
#'    inclusion thresholding.
#' * `hits.taxid`: 	The NCBI taxonomy identifier of the
#'    target (if applicable).
#' * `hits.species`: 	The species name of the target
#'    (if applicable).
#' * `hits.kg`: 	The kingdom of life that the target belongs
#'    to - based on placing in the NCBI taxonomy tree (if applicable).
#'
#' @section Domain data structure:
#' Variables beginning with "domains." have been extracted from
#'     the hash domains.
#' * `domains.ienv`: 	Envelope start position.
#' * `domains.jenv`: 	Envelope end position.
#' * `domains.iali`: 	Alignment start position.
#' * `domains.jali`: 	Alignment end position.
#' * `domains.bias`: 	null2 score contribution.
#' * `domains.oasc`: 	Optimal alignment accuracy score.
#' * `domains.bitscore`: 	Overall score in bits, null corrected,
#'     if this were the only domain in seq.
#' * `domains.cevalue`: 	Conditional E-value based on the
#'    domain correction.
#' * `domains.ievalue`: 	Independent E-value based on the
#'    domain correction.
#' * `domains.is_reported`: 	1 if domain meets reporting
#'    thresholds.
#' * `domains.is_included`: 	1 if domain meets inclusion
#'    thresholds.
#' * `domains.alimodel`: 	Aligned query consensus sequence phmmer
#'     and hmmsearch, target hmm for hmmscan.
#' * `domains.alimline`: 	Match line indicating identities,
#'  conservation +’s, gaps.
#' * `domains.aliaseq`: 	Aligned target sequence for phmmer
#'    and hmmsearch, query for hmmscan.
#' * `domains.alippline`: 	Posterior probability annotation.
#' * `domains.alihmmname`: 	Name of HMM (query sequence for phmmer,
#'     alignment for hmmsearch and target hmm for hmmscan).
#' * `domains.alihmmacc`: 	Accession of HMM.
#' * `domains.alihmmdesc`: 	Description of HMM.
#' * `domains.alihmmfrom`: 	Start position on HMM.
#' * `domains.alihmmto`: 	End position on HMM.
#' * `domains.aliM`: 	Length of model.
#' * `domains.alisqname`: 	Name of target sequence (phmmer, hmmscan)
#'     or query sequence(hmmscan).
#' * `domains.alisqacc`: 	Accession of sequence.
#' * `domains.alisqdesc`: 	Description of sequence.
#' * `domains.alisqfrom`: 	Start position on sequence.
#' * `domains.alisqto`: 	End position on sequence.
#' * `domains.aliL`: 	Length of sequence.
#'
#' @section Taxonomic data structure:
#' If annotate_taxonomic = "local" or annotate_taxonomic = "remote" is selected,
#'  as many columns as available taxonomic categories will be
#'  included. All of them will have in common that they will start with "taxa".
#' @section Theoretical physicochemical properties data structure:
#' If calculate_physicochemical_properties = TRUE the following
#'  columns will be included. All of them will have in common that
#'   they will start with "properties".
#' * `properties.molecular.weight`: sum of the masses of each
#'   atom constituting a molecule (Da) using the same formulas
#'   and weights as ExPASy's.
#' *  `properties.charge`: net charge of a protein sequence based on the
#'    Henderson-Hasselbalch equation using Lehninger pKa scale.
#' *  `properties.pI`:  isoelectric point calculated as in EMBOSS PEPSTATS.
#' * `properties.mz`: mass over charge ratio (m/z) for peptides,
#'    as measured in mass spectrometry.
#' * `properties.aIndex`: aliphatic index of a protein. The aindex
#'     is defined as the relative volume occupied by aliphatic
#'    side chains (Alanine, Valine, Isoleucine, and Leucine). It may
#'    be regarded as a positive factor for the increase of
#'    thermostability of globular proteins.
#' * `properties.boman`: potential protein interaction index.
#'    The index is equal to the sum of the solubility values for
#'    all residues in a sequence, it might give an overall estimate
#'    of the potential of a peptide to bind to membranes or other
#'    proteins as receptors, to normalize it is divided by the number
#'     of residues. A protein have high binding potential
#'     if the index value is higher than 2.48.
#' * `properties.hydrophobicity`: GRAVY hydrophobicity index of
#'    an amino acids sequence using KyteDoolittle hydophobicity scale.
#' * `properties.instaIndex`: Guruprasad's instability index.
#'    This index predicts the stability
#'    of a protein based on its amino acid composition, a protein
#'    whose instability index is smaller than 40 is predicted as
#'     stable, a value above 40 predicts that the protein may be unstable.
#' * `properties.STYNQW`: Percentage of amino acids (S + T + Y + N + Q + W)
#' * `properties.Tiny`: Percentage of amino acids (A + C + G + S + T)
#' * `properties.Small`: Percentage of amino acids
#'     (A + B + C + D + G + N + P + S + T + V)
#' * `properties.Aliphatic`: Percentage of amino acids (A + I + L + V)
#' * `properties.Aromatic`: Percentage of amino acids (F + H + W + Y)
#' * `properties.Non-polar`: Percentage of amino acids
#'    (A + C + F + G + I + L + M + P + V + W + Y)
#' * `properties.Polar`: Percentage of amino acids
#'    (D + E + H + K + N + Q + R + S + T + Z)
#' * `properties.Charged`: Percentage of amino acids
#'    (B + D + E + H + K + R + Z)
#' * `properties.Basic`: Percentage of amino acids (H + K + R)
#' @source \url{https://www.ebi.ac.uk/Tools/hmmer/search/}
#' @usage data(ABL1_homologous)
"ABL1_homologous"
