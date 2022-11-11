#' Filter dataframe depending on a column and a threshold.
#'
#' @param data Dataframe which is going to be filtered.
#' @param threshold Value used to filter the dataset.
#' @param by Column which we are going to use to filter the dataset.
#'
#' @return A DataFrame filtered.
#' 
#' @examples
#' data(phmmer_2abl)
#' filter_hmmer(
#'     data = phmmer_2abl,
#'     threshold = 0.0005,
#'     by = 'hits.evalue'
#' )
#' @export
filter_hmmer <- function(data, threshold = 0.0005, by = "hits.evalue"){
    data2 <- data.frame(data)
    
    # Extract type
    type <- strsplit(by, split = "[.]")[[1]]
    
    if (type[1] == "domains"){ # Filtering domains
    
        if (!(by %in% colnames(data))){ # Lets create column
            data2 <- data2 %>% extract_evalue_from_domains(by=type[2])
        }
    }
    
    # Filter desired column
    data2 %>% dplyr::filter(get({{by}}) < threshold)
}


extract_evalue_from_domains <- function(data, by="ievalue"){
    data2 <- data.frame(data)
  
    # Create new empty column
    new_evalue <- c()
  
    # Save number of rows
    n.rows <- nrow(data2)
  
    # Iterate over all rows
    for (row in seq_len(n.rows)){
    
        # Calculate number of domains in actual row
        n.elements <- length(data2[row,'hits.domains'][[1]])
    
        lowest <- as.double(data2[row,'hits.domains'][[1]][[1]][by])
    
        # Iterate over each domain and keep lowest
        if (n.elements > 1){ 
      
            for (el in seq_len(n.elements)){

                element <- as.double(data2[row,'hits.domains'][[1]][[el]][by])
        
                if (element < lowest){ # Keep lowest
                    lowest <- element
                }
        
            }
        }
        # Store new value
        new_evalue <- c(new_evalue, lowest)
    }
  
    # Add new column
    data2 <- cbind(data2, new_evalue)
    colnames(data2)[ncol(data2)] <- paste("domains",by,sep=".")

    data2
}
