seq <- ">2abl_A mol:protein length:163  ABL TYROSINE KINASE\nMGPSENDPNLFVALYDFVASGDNTLSITKGEKLRVLGYNHNGEWCEAQTKNGQGWVPSNYITPVNSLEKHSWYHGPVSRNAAEYLLSSGINGSFLVRESESSPGQRSISLRYEGRVYHYRINTASDGKLYVSSESRFNTLAELVHHHSTVADGLITTLHYPAP"
aln <- c(
  "FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVC",
  "-------KYRTWEEFTRAAEKLYQADPMKVRVVLKY----RHCDG",
  "EEYQTWEEFARAAEKLYLTDPMKVRVVLKYRHCDGNLCMKVTDDA"
) %>%
  Biostrings::AAMultipleAlignment() %>%
  AAMultipleAlignment_to_string()

mock_HMMER_response <- function(query_object){
  httptest::with_mock_api({
    query_object%>%
      post_HMMER_api_search() -> r
  })
  return(r)
}


test_that("It returns correct search rul", {
  return_HMMER_API_search_url("phmmer") %>%
    expect_identical("https://www.ebi.ac.uk/Tools/hmmer/search/phmmer")
})

test_that("It returns correct query object for phmmer", {
  expected_query_object <- list(
    algorithm = "phmmer",
    url = "https://www.ebi.ac.uk/Tools/hmmer/search/phmmer",
    timeout_in_seconds = 100,
    body = list(
      seq = seq,
      seqdb = "pdb"
    )
  )
  class(expected_query_object) <- "query_object"
  construct_query_object("phmmer", db = "pdb", seq, 100)%>%
    expect_equal(expected_query_object)
})

test_that("It returns correct query object for hmmscan", {
  expected_query_object <- list(
    algorithm = "hmmscan",
    url = "https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan",
    timeout_in_seconds = 100,
    body = list(
      seq = seq,
      hmmdb = "pfam"
    )
  )
  class(expected_query_object) <- "query_object"
  construct_query_object("hmmscan", db = "pfam", seq, 100)%>%
    expect_equal(expected_query_object)
})

test_that("It parses hmmscan UUID", {
  construct_query_object("hmmscan", db = "pfam", seq, 100) %>%
    mock_HMMER_response() -> r
  uuid <-"46E8B158-06A9-11ED-BD65-75562EAC1559"
  names(uuid) <- "uuid"
  r %>%
    httr::content()%>%
    XML::xmlParse()%>%
    parse_uuid_xml()%>%
    expect_equal(uuid)
})

test_that("It parses phmmer_xml", {
  construct_query_object("phmmer", db = "pdb", seq, 100) %>%
    mock_HMMER_response() -> r
  parsed_response <-parse_response_into_tbl(r)
  parsed_response$stats%>%
    expect_snapshot_value(style = "json2")
})
test_that("It parses  hmmscan xml", {
  construct_query_object("hmmscan", db = "pfam", seq, 100) %>%
    mock_HMMER_response() -> r
  parsed_response <-parse_response_into_tbl(r)
  parsed_response$hits%>%
    expect_snapshot_value(style = "json2")
})

test_that("It parses hmmsearch xml", {
  construct_query_object("hmmsearch", db = "pdb", aln, 100) %>%
    mock_HMMER_response() -> r
  parsed_response <-parse_response_into_tbl(r)
  parsed_response$domains%>%
    expect_snapshot_value(style = "json2")
})

skip("Skipping Integration test")
test_that("Returns the result for the example of phmmer", {
  construct_query_object("phmmer", db = "pdb", seq, 100)%>%
  post_HMMER_api_search()%>%
    httr::status_code()%>%
    expect_equal(200)
})

test_that("Returns the result for the example of hmmscan", {
  construct_query_object("hmmscan", db = "pfam", seq, 100)%>%
    post_HMMER_api_search()%>%
    httr::status_code()%>%
        expect_equal(200)
})

test_that("Returns the result for the example of hmmsearch", {
  construct_query_object("hmmsearch", db = "pdb", aln, 100)%>%
    post_HMMER_api_search()%>%
    httr::status_code()%>%
    expect_equal(200)
})

test_that("It fails when wrong database for hmmscan", {
  construct_query_object("hmmscan", db = "pdb", seq, 100)%>%
    post_HMMER_api_search()%>%
    httr::status_code()%>%
    expect_equal(400)
})

test_that("It fails when wrong input type for hmmsearch", {
  construct_query_object("hmmsearch", db = "pdb", seq, 100)%>%
    post_HMMER_api_search()%>%
    httr::status_code()%>%
    expect_equal(400)
})
