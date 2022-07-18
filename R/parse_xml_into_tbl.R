parse_response_into_tbl<- function(r){
  xml <- r %>%
    httr::content(encoding = "UTF-8")%>%
    XML::xmlParse()
  parse_xml_into_tbl(xml, r$algorithm)
}

parse_xml_into_tbl <- function(xml, algorithm){
  uuid <- parse_uuid_xml(xml)
  parsed_response <- list(
    "uuid" = uuid,
    "url" = get_results_url(uuid),
    "stats" = parse_hash_xml(xml, "///stats"),
    "hits" = parse_hash_xml(xml, "///hits"),
    "domains" = parse_hash_xml(xml, "///domains") %>%
      {if(algorithm == "hmmscan") purrr::flatten_dfr(.) else .}
  )
  class(parsed_response)<- "parsed_HMMER_response"
  return(parsed_response)
}


# parse_xml_into_tbl <- function(hmm, type = "default") {
#     hmm %>%
#         purrr::map(
#             purrr::possibly(
#                 otherwise = list(
#                     "uuid" = NA,
#                     "url" = NA,
#                     "stats" = NA,
#                     "hits" = NA,
#                     "domains" = NA
#                 ),
#                 ~ {
#                     xml <- XML::xmlParse(.x)
#                     uuid <- parse_uuid_xml(xml)
#                     ## parse xml
#                     list(
#                         "uuid" = uuid,
#                         "url" = get_results_url(uuid),
#                         "stats" = parse_hash_xml(xml, "///stats"),
#                         "hits" = parse_hash_xml(xml, "///hits"),
#                         "domains" = parse_hash_xml(xml, "///domains") %>%
#                           {if(type == "hmmscan") purrr::flatten_dfr(.) else .}
#                     )
#                 }
#             )
#         ) %>%
#         purrr::transpose()
# }
