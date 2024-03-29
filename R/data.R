#' phmmer_2abl
#'
#' A DataFrame with 25 results of a phmmer search of the 2abl sequence.
#' @noMd
#' @format A data frame with 49 variables:
#' \describe{
#' \item{\code{algorithm }}{HMMER algorithm}
#' \item{\code{uuid}}{unique hmmer identifier}
#' \item{\code{stats.page}}{}
#' \item{\code{stats.nhits}}{The number of hits found above reporting 
#' thresholds}
#' \item{\code{stats.elapsed}}{}
#' \item{\code{stats.Z}}{The number of sequences or models in the target 
#' database}
#' \item{\code{stats.Z_setby}}{}
#' \item{\code{stats.n_past_msv}}{}
#' \item{\code{stats.unpacked}}{}
#' \item{\code{stats.nseqs}}{}
#' \item{\code{stats.user}}{}
#' \item{\code{stats.domZ_setby}}{}
#' \item{\code{stats.n_past_bias}}{}
#' \item{\code{stats.sys}}{}
#' \item{\code{stats.n_past_fwd}}{}
#' \item{\code{stats.total}}{}
#' \item{\code{stats.nmodels}}{The number of models in this search}
#' \item{\code{stats.nincluded}}{The number of sequences or models scoring above
#'  the significance threshold}
#' \item{\code{stats.n_past_vit}}{}
#' \item{\code{stats.nreported}}{The number of sequences or models scoring above
#'  the reporting threshold}
#' \item{\code{stats.domZ}}{The number of hits in the target database}
#' \item{\code{hits.archScore}}{}
#' \item{\code{hits.ph}}{Phylum}
#' \item{\code{hits.arch}}{}
#' \item{\code{hits.kg}}{Kingdom}
#' \item{\code{hits.ndom}}{Total number of domains identified in this sequence}
#' \item{\code{hits.extlink}}{}
#' \item{\code{hits.fullfasta}}{Protein sequences as a character vector.}
#' \item{\code{hits.taxid}}{The NCBI taxonomy identifier of the target (if 
#' applicable)}
#' \item{\code{hits.acc}}{Accession of the target}
#' \item{\code{hits.taxlink}}{}
#' \item{\code{hits.desc}}{Description of the target}
#' \item{\code{hits.pvalue}}{P-value of the score}
#' \item{\code{hits.flags}}{}
#' \item{\code{hits.nregions}}{Number of regions evaluated}
#' \item{\code{hits.niseqs}}{}
#' \item{\code{hits.name}}{Name of the target (sequence for phmmer/hmmsearch, 
#' HMM for hmmscan)}
#' \item{\code{hits.species}}{The species name of the target (if applicable)}
#' \item{\code{hits.score}}{Bit score of the sequence (all domains, without 
#' correction)}
#' \item{\code{hits.bias}}{}
#' \item{\code{hits.sindex}}{}
#' \item{\code{hits.nincluded}}{Number of domains satisfying inclusion 
#' thresholding}
#' \item{\code{hits.domains}}{The domain or hit hash contains the details of the
#'  match, in particular the alignment between the query and the target.}
#' \item{\code{hits.pdbs}}{Array of pdb identifiers (which chains information)}
#' \item{\code{hits.evalue}}{E-value of the score}
#' \item{\code{hits.nreported}}{Number of domains satisfying reporting 
#' thresholding}
#' \item{\code{hits.archindex}}{}
#' \item{\code{hits.acc2}}{Secondary accession of the target}
#' }
#'
#' For further details, see 
#' \url{https://hmmer-web-docs.readthedocs.io/en/latest/appendices.html}
#'
"phmmer_2abl"

#' hmmscan_2abl
#'
#' A DataFrame with 4 results of a hmmscan search of the 2abl sequence.
#' @noMd
#' @format A data frame with 36 variables:
#' \describe{
#' \item{\code{algorithm }}{HMMER algorithm}
#' \item{\code{uuid}}{unique hmmer identifier}
#' \item{\code{stats.page}}{}
#' \item{\code{stats.nhits}}{The number of hits found above reporting 
#' thresholds}
#' \item{\code{stats.elapsed}}{}
#' \item{\code{stats.Z}}{The number of sequences or models in the target 
#' database}
#' \item{\code{stats.Z_setby}}{}
#' \item{\code{stats.n_past_msv}}{}
#' \item{\code{stats.unpacked}}{}
#' \item{\code{stats.nseqs}}{}
#' \item{\code{stats.user}}{}
#' \item{\code{stats.domZ_setby}}{}
#' \item{\code{stats.n_past_bias}}{}
#' \item{\code{stats.sys}}{}
#' \item{\code{stats.n_past_fwd}}{}
#' \item{\code{stats.total}}{}
#' \item{\code{stats.nmodels}}{The number of models in this search}
#' \item{\code{stats.nincluded}}{The number of sequences or models scoring above
#'  the significance threshold}
#' \item{\code{stats.n_past_vit}}{}
#' \item{\code{stats.nreported}}{The number of sequences or models scoring above
#'  the reporting threshold}
#' \item{\code{stats.domZ}}{The number of hits in the target database}
#' \item{\code{hits.acc}}{Accession of the target}
#' \item{\code{hits.desc}}{Description of the target}
#' \item{\code{hits.pvalue}}{P-value of the score}
#' \item{\code{hits.flags}}{}
#' \item{\code{hits.nregions}}{}
#' \item{\code{hits.taxid}}{}
#' \item{\code{hits.nreported}}{}
#' \item{\code{hits.hindex}}{}
#' \item{\code{hits.ndom}}{Total number of domains identified in this sequence}
#' \item{\code{hits.name}}{Name of the target (sequence for phmmer/hmmsearch, 
#' HMM for hmmscan)}
#' \item{\code{hits.score}}{Bit score of the sequence (all domains, without 
#' correction)}
#' \item{\code{hits.bias}}{}
#' \item{\code{hits.domains}}{The domain or hit hash contains the details of the
#'  match, in particular the alignment between the query and the target.}
#' \item{\code{hits.evalue}}{E-value of the score}
#' \item{\code{hits.nincluded}}{E-value of the score}
#' }
#'
#' For further details, see 
#' \url{https://hmmer-web-docs.readthedocs.io/en/latest/appendices.html}
#'
"hmmscan_2abl"
