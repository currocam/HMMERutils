return_HMMER_API_search_url<- function(algoritm){
  path <- paste("Tools/hmmer/search", algoritm, sep = "/")
  httr::modify_url("https://www.ebi.ac.uk/", path = path)
}

